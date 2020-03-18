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
# version   1.1.4
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

function inform()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;34mINFO\033[0m\t$1" | tee -a "$LOG"
}
export -f inform

function err()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[0;31mERROR\033[0m\t$1" | tee -a "$LOG"
}
export -f err

function warn()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;33mWARNING\033[0m\t$1" | tee -a "$LOG"
}
export -f warn

function succ()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;32mSUCCESS\033[0m\t$1" | tee -a "$LOG"
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
        
        &>>"$LOG" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
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

function ensure() {
    if ! "$@"; then
		echo ''
		err "Command failed: $*\n\t\t\t\t\t\t\tAborting"
		exit 1
	fi
}
export -f ensure

function test_on_success() {
	if "$@" &>/dev/null; then
	    printf 'success.\n'
	else
	    printf 'unsuccessfull.\n'
	fi
}
export -f test_on_success

function update () {
	set -e
    local DIR="${HOME}/.update_log"
    local OPTIONS=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)

    sudo printf ""

	if [[ $? -ne 0 ]]; then
		echo ''
		err 'User input invalid. Aborting.'
		exit 1
	fi

    inform 'New update started' "$DIR"

    inform 'Checking for updates' "$DIR"
    ensure sudo apt-get update "&>>${DIR}"

    inform 'Installing updates' "$DIR"
    ensure sudo apt-get ${OPTIONS[@]} upgrade "&>>${DIR}"

    inform 'Removing orphaned packages' "$DIR"
    ensure sudo apt-get ${OPTIONS[@]} autoremove "&>>${DIR}"

    inform 'Clearing apt cache' "$DIR"
    ensure sudo apt-get ${OPTIONS[@]} autoclean "&>>${DIR}"

    inform 'Updating via SNAP' "$DIR"
    ensure sudo snap refresh "&>>${DIR}"

    if [[ ! -z $(which rustup) ]]; then
        inform 'Updating RUST via rustup' "$DIR"
        ensure rustup update "&>>${DIR}"
    fi

	set +e
    succ 'Completed update' "$DIR"
    return
}
export -f update
