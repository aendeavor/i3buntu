#! /bin/bash
#        ____  ___   _____ __  __     ___    __    _______   _____ ___________
#       / __ )/   | / ___// / / /    /   |  / /   /  _/   | / ___// ____/ ___/
#      / __  / /| | \__ \/ /_/ /    / /| | / /    / // /| | \__ \/ __/  \__ \ 
#   _ / /_/ / ___ |___/ / __  /    / ___ |/ /____/ // ___ |___/ / /___ ___/ / 
#  (_)_____/_/  |_/____/_/ /_/____/_/  |_/_____/___/_/  |_/____/_____//____/  
#                           /_____/
#
# ! BASH_ALIASES - ADDITIONAL CONFIGURATION FILE FOR BASH
# ! ${HOME}/.bash_aliases
#
# version   1.3.0 [24 Nov 2020]
# author    Georg Lauterbach
# executed  from ${HOME}/.bashrc
# patched   for macOS and Bash v5

###########################################################

# check color support
if [[ -x /usr/bin/dircolors ]]
then
	if [[ -r "${HOME}/.dircolors" ]]
		then dircolors -b "${HOME}/.dircolors"
		else dircolors -b
	fi
fi

# ? Aliases

alias ls='ls -lhG'
alias lsa='ls -lhAG'
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

# ? Functions

function sf () {
	find . \
		-maxdepth 2 \
		-iregex "[a-z0-9_\.\/\ ]*${1:?Enter a search-regex}" \
		-type f
}
export -f sf
