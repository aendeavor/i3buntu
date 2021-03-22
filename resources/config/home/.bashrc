#! /bin/bash

#        ____  ___   _____ __  ______  ______
#       / __ )/   | / ___// / / / __ \/ ____/
#      / __  / /| | \__ \/ /_/ / /_/ / /     
#     / /_/ / ___ |___/ / __  / _, _/ /___   
#  (_)_____/_/  |_/____/_/ /_/_/ |_|\____/   

# version       1.0.0 [21 Mar 2021]
# executed by   Bash for non-login shells
# location      ${HOME}/.bashrc
# loads         ${HOME}/.bash_aliases

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Confiuration file for Bash 5
# ––
# ? >> Trap and log setup
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

set -uE -o pipefail

trap '__terminate' EXIT SIGTERM SIGINT
trap '__log "${BASH_COMMAND}" ${FUNCNAME[0]:-?} ${LINENO} ${?}' ERR

function __terminate 
{
  unset __main __miscellaneous __prompt __completion
  set +uE +o pipefail
  trap - ERR
}

function __log
{
  echo -e "\n$(date +"%T")  ${HOME}/.bashrc
\t  Error during '${1}' in function '${2}' on line ${3} (${4})"
}

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Trap and log setup
# ––
# ? >> Declaration of setup functions
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

function __miscellaneous
{
  VISUAL=nvim ; EDITOR="$VISUAL"
  GCC_COLORS='error=01;31:warning=01;35:note=01;36:'
  GCC_COLORS+='caret=01;32:locus=01:quote=01'

  HISTCONTROL=ignoreboth
  HISTSIZE=10000
  HISTFILESIZE=10000

  export VISUAL EDITOR GCC_COLORS
  export HISTCONTROL HISTSIZE HISTFILESIZE

  shopt -s histappend checkwinsize globstar autocd

  # more friendly less for non-text input files
  local LP=/usr/bin/lesspipe
  [[ -x ${LP} ]] && eval "$(SHELL=/bin/sh ${LP})"

  if command -v batcat &>/dev/null
  then
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export MANROFFOPT="-c"
    export PAGER='less -R'
    export BAT_PAGER="less -R"
  fi

  if  [[ ! -x /usr/bin/dircolors ]] || \
	    [[ ! -r "${HOME}/.dircolors" ]] || \
	    ! eval "$(dircolors -b "${HOME}/.dircolors")"
  then
  	eval "$(dircolors -b)"
  fi
}

function __prompt
{
  PROMPT_DIRTRIM=4

  # set variable identifying chroot you work in
  if [[ -z ${debian_chroot:-} ]] && [[ -r /etc/debian_chroot ]]
  then
    debian_chroot=$(cat /etc/debian_chroot)
  fi

  if [[ -x /usr/bin/tput ]] && tput setaf 1 &>/dev/null
  then
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+='\[\033[01;32m\]\u\[\033[00m\]@'
    PS1+='\[\033[01;32m\]\h\[\033[00m\] : '
    PS1+='\[\033[01;34m\]\w\[\033[00m\] \$ '
  else
    PS1=' ${debian_chroot:+($debian_chroot)}'
    PS1+='\u@\h : \w \$ '
  fi	
}

function __completion
{
  if ! shopt -oq posix
  then
    if   [[ -f /usr/share/bash-completion/bash_completion ]]
    then
      . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]
    then
      . /etc/bash_completion
    fi
  fi
}

function nf
{
  printf '\n'
  neofetch \
    --ascii --ascii_bold on --gap 3 \
    --ascii_distro LinuxLite_small --color_blocks off \
    --disable term uptime packages resolution theme icons cpu gpu memory \
    --underline_char ' ' --separator ' ' \
    --bold on --gtk3 on
}

function __main
{
  # nf

  # if not running interactively, don't do anything
  [[ ! ${-} == *i* ]] && return

  __completion
  __prompt
  __miscellaneous

  # shellcheck source=/dev/null
  [[ -f ${HOME}/.bash_aliases ]] && . "${HOME}/.bash_aliases"
}

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Declaration of setup functions
# ––
# ? >> Execution of setup functions
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

__main "${@}"
__terminate

