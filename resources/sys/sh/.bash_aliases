# ! BASH ALIASES - ADDITIONAL CONFIG FILE EXTENDING ~/.bashrc
# ! ~/.bash_aliases - executed in ~/.bashrc

# This bash script is executed on bash startup
# from ~/.bashrc to load all aliases and
# functions defined in this scope.
#
# current version - 0.8.2

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

alias lsa='ls -lha'
alias datetime='date && cal'
alias df='df -h'
alias sd='blkid -o list'
alias path='echo $PATH'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias rm='rm -r'
alias echo='echo -e'
alias sizeof='du -sh'

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

areinstall () {
    sudo apt-get install --reinstall "$1"
    return
}
export -f areinstall

update () {
    DIR="${HOME}/.update_log"
    OPTIONS=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)

    sudo printf "\n\n\nNew update started at: " >> "$DIR"
    date >> $DIR

    printf "\n\e[38;5;203mUpdate process started!\e[39m\n\n"

    echo -e "Checking for updates..." | tee -a "$DIR"
    # * &>> is the same as >>"$DIR" 2>&1
    sudo apt-get update &>>"$DIR"

    echo -e "Installing updates..." | tee -a "$DIR"
    sudo apt-get ${OPTIONS[@]} upgrade &>> "$DIR"

    echo -e "Removing ophaned packages..." | tee -a "$DIR"
    sudo apt-get ${OPTIONS[@]} autoremove &>> "$DIR"

    echo -e "Clearing apt cache..." | tee -a "$DIR"
    sudo apt-get ${OPTIONS[@]} autoremove &>> "$DIR"

    echo -e "Getting snap updates done..."
    sudo snap refresh &>> "$DIR"

    if [[ ! -z $(which rustup) ]]; then
        echo -e "Updating RUST via rustup..." | tee -a "$DIR"
        rustup update &>>"$DIR"
    fi

    printf "\n\e[38;5;194mCompleted task!\e[39m\n\n"
    printf "Completed task!\n\n\n" >>"$DIR"
    return
}
export -f update

sf () {
    ls -lha | grep $1
    return
}
export -f sf

open () {
    evince "$1" > /dev/null 2>&1 &
    return
}
export -f open

shutn () {
    shutdown now
    return
}
export -f shutn

