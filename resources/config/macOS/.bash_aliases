#! /bin/bash

#      ___    __    _______   _____ ___________
#     /   |  / /   /  _/   | / ___// ____/ ___/
#    / /| | / /    / // /| | \__ \/ __/  \__ \ 
#   / ___ |/ /____/ // ___ |___/ / /___ ___/ / 
#  /_/  |_/_____/___/_/  |_/____/_____//____/  

# version       3.0.0 [21 Mar 2021]
# executed by   ${HOME}/.bashrc
# location      ${HOME}/.bash_aliases

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Additional (alias) confiuration file for Bash 5
# ––
# ? >> Definition of aliases
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

alias bat='cat'
alias f='fuck'
alias ls='ls -lh --color=auto'
alias lsa='ls -lhA --color=auto'
alias less='less -R'
alias grep='grep --color=auto'
alias datetime='date && cal'
alias df='df -h'
alias sd='blkid -o list'
alias sizeof='du -sh'

alias v='nvim'
alias sv='sudo nvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
