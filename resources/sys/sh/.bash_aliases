#!/bin/bash
#        ____  ___   _____ __  __     ___    __    _______   _____ ___________
#       / __ )/   | / ___// / / /    /   |  / /   /  _/   | / ___// ____/ ___/
#      / __  / /| | \__ \/ /_/ /    / /| | / /    / // /| | \__ \/ __/  \__ \ 
#   _ / /_/ / ___ |___/ / __  /    / ___ |/ /____/ // ___ |___/ / /___ ___/ / 
#  (_)_____/_/  |_/____/_/ /_/____/_/  |_/_____/___/_/  |_/____/_____//____/  
#                           /_____/
#
# ! BASH_ALIASES - ADDITIONAL CONFIGURATION FILE FOR BASH
# ! $HOME/.bash_aliases
#
# Executed from $HOME/.bashrc
#
# version   1.2.10
# author    aendeavor@Georg Lauterbach

###########################################################

# shellcheck disable=SC2024

# check color support
if [ -x /usr/bin/dircolors ]; then
    if [[ -r ${HOME}/.dircolors ]] && eval "$(dircolors -b "${HOME}/.dircolors")"; then
		true
	else
		eval "$(dircolors -b)"
	fi
fi

# ? Aliases

alias ls='ls -lh --color=auto'
alias lsa='ls -lhA --color=auto'
alias grep='grep --color=auto'
alias datetime='date && cal'
alias df='df -h'
alias sd='blkid -o list'
alias sizeof='du -sh'
alias vmp='sudo vmplayer &>/dev/null &'

alias v='nvim'
alias sv='sudo nvim'

alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ? Functions

## ? Logger

function inform() {
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%H:%M:%S') \033[1;34mINFO\033[0m\t\t$1" | tee -a "$LOG" # +%d.%m.%Y
}
export -f inform

function err() {
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%H:%M:%S') \033[0;31mERROR\033[0m\t$1" | tee -a "$LOG"
}
export -f err

function warn() {
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%H:%M:%S') \033[1;33mWARNING\033[0m\t$1" | tee -a "$LOG"
}
export -f warn

function succ() {
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%H:%M:%S') \033[1;32mSUCCESS\033[0m\t$1" | tee -a "$LOG"
}
export -f succ

## ? Non-Logger

function a () {
    sudo apt-get "$@"
}
export -f a

function sf () {
    SEARCH=${1:?Enter a search-regex}
    MAXDEPTH=${2:-1}
    find . -maxdepth "$MAXDEPTH" -iregex "[a-z0-9_\.\/\ ]*${SEARCH}[a-z0-9_\.\/\ ]*" -type f
}
export -f sf

function shutn () {
    shutdown now
}
export -f shutn

## ? Script functions

function test_on_success() {
	local LOG=$1
	shift
	if "$@" &>/dev/null; then
	    printf 'successful.' | tee -a "$LOG"
	else
	    printf 'unsuccessful.' | tee -a "$LOG"
	fi
}
export -f test_on_success

function ensure() {
    if ! "$@"; then
		echo ''
		err "Command failed: $*\n\t\tAborting." 1>&2
		exit 1
	fi
}
export -f ensure

function script_update()
{
	set -u
    local LOG=$1

    local OPTIONS=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )

	{ echo ''; warn 'New update started'; } >> "$LOG"

    inform 'Checking for updates' >> "$LOG"
    ensure sudo apt-get update >/dev/null

    inform 'Installing updates' >> "$LOG"
    ensure sudo apt-get "${OPTIONS[@]}" upgrade >/dev/null

    inform 'Removing orphaned packages' >> "$LOG"
    ensure sudo apt-get "${OPTIONS[@]}" autoremove >/dev/null

    inform 'Clearing apt cache' >> "$LOG"
    ensure sudo apt-get "${OPTIONS[@]}" autoclean >/dev/null

	[[ -z $(which snap) ]] || inform 'Updating via SNAP' >> "$LOG"; sudo snap refresh &>/dev/null;
    [[ -z $(which rustup) ]] || inform 'Updating RUST via rustup' >> "$LOG"; rustup update &>/dev/null;

    succ "Completed update\n" >> "$LOG"
	set +u
}
export -f script_update

## ? Update function

function update()
{
    if ! sudo printf ""; then
		echo ''
		err 'User input invalid. Aborting.'
		return 1
	fi
    
	local LOG="${HOME}/.update_log"
	touch "$LOG"

    local OPTIONS=( --yes --assume-yes --allow-unauthenticated --allow-change-held-packages )

	local RIP

	echo '' >> "$LOG"
    warn 'New update started' "$LOG"

	echo '' >> "$LOG"
    inform 'Checking for updates' "$LOG"
    sudo apt-get update &>>"$LOG"
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get update returned with error code $RIP"
		return 1
	fi

	echo '' >> "$LOG"
    inform 'Installing updates' "$LOG"
    sudo apt-get --with-new-pkgs "${OPTIONS[@]}" upgrade &>>"$LOG"
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get upgrade returned with error code $RIP"
		return 1
	fi

	echo '' >> "$LOG"
    inform 'Removing orphaned packages' "$LOG"
    sudo apt-get "${OPTIONS[@]}" autoremove &>>"$LOG"
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get autoremove returned with error code $RIP"
		return 1
	fi

	if [ -n "$(which snap)" ]; then
		echo '' >> "$LOG"
    	inform 'Updating via SNAP' "$LOG"
    	sudo snap refresh &>>"$LOG"
		RIP=$?
		if [[ $RIP -ne 0 ]]; then
			err "sudo snap refresh returned with error code $RIP"
			return 1
		fi
	fi

    if [ -n "$(which rustup)" ]; then
		echo '' >> "$LOG"
		inform 'Updating RUST via rustup' "$LOG"
        rustup update &>>"$LOG"
		RIP=$?
		if [[ $RIP -ne 0 ]]; then
			err "sudo apt-get update returned with error code $RIP"
			return 1
		fi
    fi

	echo '' >> "$LOG"
    succ 'Completed update' "$LOG"
	echo '' >> "$LOG"
}
export -f update
