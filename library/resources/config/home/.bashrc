#! /bin/bash
#        ____  ___   _____ __  ______  ______
#       / __ )/   | / ___// / / / __ \/ ____/
#      / __  / /| | \__ \/ /_/ / /_/ / /     
#   _ / /_/ / ___ |___/ / __  / _, _/ /___   
#  (_)_____/_/  |_/____/_/ /_/_/ |_|\____/   
#
# ! BASHRC - CONFIGURATION FILE FOR BASH
# ! ${HOME}/.bashrc
# 
# version   0.9.1 [18 Dec 2020]
# author    Georg Lauterbach
# executed  by BASH for non-login shells
# loads     ${HOME}/.bash_aliases
#
###########################################################

function miscellaneous
{
	stty -ixon

	export VISUAL=nvim
	export EDITOR="$VISUAL"

	shopt -s histappend checkwinsize globstar autocd

	# more friendly less for non-text input files
	local LP=/usr/bin/lesspipe
	[[ -x ${LP} ]] && eval "$(SHELL=/bin/sh ${LP})"

	# colored GCC warnings and errors
	export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

	# history parametes
	export HISTCONTROL=ignoreboth
	export HISTSIZE=10000
	export HISTFILESIZE=10000

	# setup bat as pager from man
	export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
	export MANROFFOPT="-c"
	export PAGER='less -R'
	export BAT_PAGER="less -R"

	if [[ -e "${HOME}/.cargo/env" ]]
	then
		source "${HOME}/.cargo/env"
	fi
}

function prompt
{
	# set variable identifying chroot you work in
	if [[ -z ${debian_chroot:-} ]] && [[ -r /etc/debian_chroot ]]
	then
		debian_chroot=$(cat /etc/debian_chroot)
	fi

	if [[ -x /usr/bin/tput ]] && tput setaf 1 &>/dev/null
	then
		PS1=' ${debian_chroot:+($debian_chroot)}'
		# PS1+='\[\e[38;5;11m\][\u@\h]\[\e[0m\] : '

		PS1+='\[\e[38;5;215m\]\w'
		PS1+='\[\e[0m\] \$ '

		PROMPT_DIRTRIM=4
	else
		PS1=' ${debian_chroot:+($debian_chroot)}'
		PS1+='[\u@\h] : [ \w ] \$ '
	fi
}

function programmable_completion
{
	if ! shopt -oq posix
	then
		if [[ -f /usr/share/bash-completion/bash_completion ]]
		then
			. /usr/share/bash-completion/bash_completion
		elif [[ -f /etc/bash_completion ]]
		then
			. /etc/bash_completion
		fi
	fi

	if command -v thefuck &>/dev/null
	then
		eval "$(thefuck --alias)"
	fi
}

function neofetch_parameterized
{
	neofetch \
		--ascii --ascii_bold on --gap 3 \
		--ascii_distro LinuxLite_small --color_blocks off \
		--ascii_colors 215 --colors 215 255 255 215 250 255 \
		--disable term uptime packages resolution theme icons cpu gpu memory \
		--underline_char ' ' --separator ' ' \
		--bold on --gtk3 on
}

function main
{
	# if not running interactively, don't do anything
	case ${-} in
		*i* )      ;;
		*   ) exit ;;
	esac

	miscellaneous
	prompt

	if [[ -f ${HOME}/.bash_aliases ]]
	then
		# shellcheck source=/dev/null
		. "${HOME}/.bash_aliases"
	fi

	programmable_completion
	neofetch_parameterized
}

main "${@}"
