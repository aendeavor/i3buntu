# ! BASH ALIASES & FUNCTIONS
# ! additional config file
# ! extending and executed in ~/.bashrc

# This bash script is executed on bash startup
# from ~/.bashrc to load all aliases and
# functions defined in this scope.
#
# current version - 0.9.1

# check color support
if [ -x /usr/bin/dircolors ]; then
    test -r "${HOME}/.dircolors" && eval "$(dircolors -b "${HOME}/.dircolors")" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -lh'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls='ls -lh'
fi

# ? Aliases

alias ls='ls -lh'
alias lsa='ls -lha'
alias datetime='date && cal'
alias df='df -h'
alias sd='blkid -o list'
alias sizeof='du -sh'
alias evince='evince "$1" > /dev/null 2>&1 &'

alias v="nvim"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ? Functions

## ? Logger

inform()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;34mINFO\033[0m\t$1" | tee -a "$LOG"
}
export -f inform

err()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[0;31mERROR\033[0m\t$1" | tee -a "$LOG"
}
export -f err

warn()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;33mWARNING\033[0m\t$1" | tee -a "$LOG"
}
export -f warn

succ()
{
    local LOG=${2:-"/dev/null"}
    echo -e "$(date '+%d.%m.%Y %H:%M:%S') \033[1;32mSUCCESS\033[0m\t$1" | tee -a "$LOG"
}
export -f succ

# uninstall a package and log the uninstall-process
uninstall_and_log()
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

a () {
    sudo apt-get "$1" "$2" "$3" "$4" "$5"
    return
}
export -f a

sv () {
    sudo vi "$1"
    return
}
export -f sv

sf () {
    SEARCH={$1:?Enter a search-regex}
    MAXDEPTH={$2:-5}
    find . -maxdepth $MAXDEPTH -iregex "[a-z0-9_\.\/\ ]*${SEARCH}" -type f
    ls -lha | grep $1
    return
}
export -f sf

shutn () {
    shutdown now
    return
}
export -f shutn

update () {
    local DIR="${HOME}/.update_log"
    local OPTIONS=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)

    # ? Actual function begins
    sudo printf ""
    inform 'New update started' "$DIR"

    inform 'Checking for updates' "$DIR"
    sudo apt-get update &>>"$DIR"

    inform 'Installing updates' "$DIR"
    sudo apt-get ${OPTIONS[@]} dist-upgrade &>> "$DIR"

    inform 'Removing orphaned packages' "$DIR"
    sudo apt-get ${OPTIONS[@]} autoremove &>> "$DIR"

    inform 'Clearing apt cache' "$DIR"
    sudo apt-get ${OPTIONS[@]} autoremove &>> "$DIR"

    inform 'Updating via SNAP' "$DIR"
    sudo snap refresh &>> "$DIR"

    if [[ ! -z $(which rustup) ]]; then
        inform 'Updating RUST via rustup' "$DIR"
        rustup update &>>"$DIR"
    fi

    succ 'Completed update' "$DIR"
    return
}
export -f update
