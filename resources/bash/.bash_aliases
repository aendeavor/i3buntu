# ! BASH ALIASES - ADDITIONAL CONFIG FILE EXTENDING ~/.bashrc
# ! ~/.bash_aliases - executed in ~/.bash

# check color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
alias rm='rm -r'
alias echo='echo -e'
alias sizeof='du -sh'

a () {
    sudo apt-get "$1" "$2"
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
    DIR=~/.update_log
    options=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)

    sudo printf "\n\n\nNew update started at: " >> $DIR
    date >> $DIR

    printf "\n\e[38;5;203mUpdate process started!\e[39m\n\n"

    echo -e "Checking for updates..." | tee -a $DIR
    sudo apt-get update 2>&1 >> $DIR

    echo -e "Installing updates..." | tee -a $DIR
    sudo apt-get ${options[@]} upgrade 2>&1 >> $DIR

    echo -e "Removing ophaned packages..." | tee -a $DIR
    sudo apt-get ${options[@]} autoremove 2>&1 >> $DIR

    echo -e "Clearing apt cache..." | tee -a $DIR
    sudo apt-get ${options[@]} autoremove 2>&1 >> $DIR

    echo -e "Getting snap updates done..."
    sudo snap refresh 2>&1 >> /dev/null 

    printf "\n\e[38;5;194mCompleted task!\e[39m\n\n"
    printf "Completed task!\n\n\n" >> $DIR
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

