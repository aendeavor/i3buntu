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
# version   1.2.9
# author    aendeavor@Georg Lauterbach

###########################################################

# check color support
if [ -x /usr/bin/dircolors ]; then
    test -r "${HOME}/.dircolors" && eval "$(dircolors -b "${HOME}/.dircolors")" || eval "$(dircolors -b)"
fi

# ? Aliases

alias ls='ls -lh --color=auto'
alias lsa='ls -lha --color=auto'
alias grep='grep --color=auto'
alias datetime='date && cal'
alias df='df -h'
alias sd='blkid -o list'
alias sizeof='du -sh'
alias vmp='sudo vmplayer &>/dev/null &'

alias v='nvim'
alias sv='sudo nvim'

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

# uninstall a package and log the uninstall-process
function uninstall_and_log()
{
    local LOG=${1:-"/dev/null"}
    shift

    local IF=(
        --yes
        --allow-unauthenticated
        --allow-downgrades
        --allow-remove-essential
        --allow-change-held-packages
    )
    
    # cannot just use $*, because when logging, we need to do
    # it iteratively, so we use $@
    for PACKAGE in $@; do
        >/dev/null 2>>"${LOG}" sudo apt-get remove ${IF[@]} "$PACKAGE"
        EC=$?

        if (( $EC != 0 )); then
            printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Removed" "${EC}"
        else
            printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Removed" "${EC}"
        fi
        printf "\n"
        
        &>>"$LOG" echo -e "${PACKAGE} (${EC})"
    done
}

## ? Non-Logger

function a () {
    ensure sudo apt-get "$*"
    return
}
export -f a

function sf () {
    SEARCH=${1:?Enter a search-regex}
    MAXDEPTH=${2:-1}
    find . -maxdepth $MAXDEPTH -iregex "[a-z0-9_\.\/\ ]*${SEARCH}" -type f
    ls -lha | grep $1
    return
}
export -f sf

function shutn () {
    shutdown now
    return
}
export -f shutn

## ? Script functions

function test_on_success() {
	local LOG=$1
	shift
	if "$@" &>/dev/null; then
	    printf 'successful.' | tee -a $LOG
	else
	    printf 'unsuccessful.' | tee -a $LOG
	fi
}
export -f test_on_success

function ensure() {
    if ! "$@"; then
		echo ''
		err "Command failed: $*\n\t\t\t\t\t\t\tAborting"
		exit 1
	fi
}
export -f ensure

function script_update()
{
	set -u
    local LOG=$1

    local OPTIONS=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )

	echo '' >> "$LOG"
    warn 'New update started' >> "$LOG"

    inform 'Checking for updates' >> "$LOG"
    1>&2 ensure >/dev/null sudo apt-get update

    inform 'Installing updates' >> "$LOG"
    1>&2 ensure >/dev/null sudo apt-get ${OPTIONS[@]} upgrade

    inform 'Removing orphaned packages' >> "$LOG"
    1>&2 ensure >/dev/null sudo apt-get ${OPTIONS[@]} autoremove

    inform 'Clearing apt cache' >> "$LOG"
    1>&2 ensure >/dev/null sudo apt-get ${OPTIONS[@]} autoclean

	if [[ ! -z $(which snap) ]]; then
	    inform 'Updating via SNAP' >> "$LOG"
	    &>/dev/null sudo snap refresh
	fi

    if [[ ! -z $(which rustup) ]]; then
		inform 'Updating RUST via rustup' >> "$LOG"
        &>/dev/null rustup update
    fi

    succ "Completed update\n" >> "$LOG"
	set +u
}
export -f script_update

## ? Update function

function update()
{
    local LOG="${HOME}/.update_log"
	touch $LOG

    local OPTIONS=( --yes --assume-yes --allow-unauthenticated --allow-change-held-packages )

	local RIP

    sudo printf ""
	if [[ $? -ne 0 ]]; then
		echo ''
		err 'User input invalid. Aborting.'
		return 1
	fi

	echo '' >> "$LOG"
    warn 'New update started' "$LOG"

	echo '' >> "$LOG"
    inform 'Checking for updates' "$LOG"
    &>>"$LOG" sudo apt-get update
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get update returned with error code $RIP"
		return 1
	fi

	echo '' >> "$LOG"
    inform 'Installing updates' "$LOG"
    &>>"$LOG" sudo apt-get --with-new-pkgs ${OPTIONS[@]} upgrade
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get upgrade returned with error code $RIP"
		return 1
	fi

	echo '' >> "$LOG"
    inform 'Removing orphaned packages' "$LOG"
    &>>"$LOG" sudo apt-get ${OPTIONS[@]} autoremove
	RIP=$?
	if [[ $RIP -ne 0 ]]; then
		err "sudo apt-get autoremove returned with error code $RIP"
		return 1
	fi

	if [[ ! -z $(which snap) ]]; then
		echo '' >> "$LOG"
    	inform 'Updating via SNAP' "$LOG"
    	&>>"$LOG" sudo snap refresh
		RIP=$?
		if [[ $RIP -ne 0 ]]; then
			err "sudo snap refresh returned with error code $RIP"
			return 1
		fi
	fi

    if [[ ! -z $(which rustup) ]]; then
		echo '' >> "$LOG"
		inform 'Updating RUST via rustup' "$LOG"
        &>>"$LOG" rustup update
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
