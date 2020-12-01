#! /bin/bash

#      ___    __    _______   _____ ___________
#     /   |  / /   /  _/   | / ___// ____/ ___/
#    / /| | / /    / // /| | \__ \/ __/  \__ \ 
#   / ___ |/ /____/ // ___ |___/ / /___ ___/ / 
#  /_/  |_/_____/___/_/  |_/____/_____//____/  

# ! BASH_ALIASES - ADDITIONAL CONFIGURATION FILE FOR BASH
# ! ${HOME}/.bash_aliases

# version   2.0.1 [25 Nov 2020]
# author    Georg Lauterbach
# executed  by ${HOME}/.bashrc

#################################################

# check color support
if  [[ ! -x /usr/bin/dircolors ]] || \
	[[ ! -r "${HOME}/.dircolors" ]] || \
	! eval "$(dircolors -b "${HOME}/.dircolors")"
then
	eval "$(dircolors -b)"
fi

# ? ––––––––––––––––––––––––––––––––––––––––––––– Aliases

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

# ? ––––––––––––––––––––––––––––––––––––––––––––– Functions

function sf
{
	local SEARCH=${1:?Enter a search-regex}
	find . -maxdepth "${2:-1}" -iname "*${SEARCH}*" -type "${3:-f}"
}
export -f sf

function shutn { shutdown now ; }
export -f shutn

function update
(
	function __update
	{
		function dt   { printf "%s " "$(date '+%H:%M:%S')"            ; }
		function inf  { echo -e "$(dt)\033[1;34mINFO\033[0m\t\t${1}"  ; }
		function err  { echo -e "$(dt)\033[0;31mERROR\033[0m\t\t${1}" ; }
		function warn { echo -e "$(dt)\033[1;33mWARNING\033[0m\t${1}" ; }
		function succ { echo -e "$(dt)\033[1;32mSUCCESS\033[0m\t${1}" ; }

		local LOG=${1:?}
		local ERR=0

		local OPTIONS=(
			--yes
			--assume-yes
			--allow-unauthenticated
			--allow-change-held-packages
		)

		: >"${LOG}"

		warn 'New update started'
		inf 'Checking for updates'

		if ! apt-get update &>>"${LOG}"
		then
			err "Could not update APT signatures [${?}]"
			return 2
		fi

		inf 'Installing updates'

		if ! apt-get --with-new-pkgs "${OPTIONS[@]}" upgrade &>>"${LOG}"
		then
			err "APT upgrade exited with an error [${?}]"
			return 2
		fi

		inf 'Removing orphaned packages'

		if ! apt-get "${OPTIONS[@]}" autoremove &>>"${LOG}"
		then
			err "APT autoremove exited with an error [${?}]"
			ERR=1
		fi

		if command -v snap &>/dev/null
		then
			inf 'Updating via SNAP'
			if ! snap refresh &>>"${LOG}"
			then
				err "Could not refresh snaps [${?}]"
				ERR=1
			fi
		fi

		if command -v rustup &>/dev/null
		then
			inf 'Updating RUST via rustup'
			if ! rustup update &>>"${LOG}"
			then
				err "Could not update Rust via rustup [${?}]"
				ERR=1
			fi
		fi

		if [[ ${ERR} -eq 0 ]]
		then
			succ 'Completed update'
		else
			warn 'Completed update with errors'
		fi
	}

	sudo env PATH="$PATH" bash -c \
		"$(declare -f __update); __update '${HOME}'/.update_log"
)
export -f update
