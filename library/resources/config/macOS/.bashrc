#!/bin/bash
#        ____  ___   _____ __  ______  ______
#       / __ )/   | / ___// / / / __ \/ ____/
#      / __  / /| | \__ \/ /_/ / /_/ / /     
#   _ / /_/ / ___ |___/ / __  / _, _/ /___   
#  (_)_____/_/  |_/____/_/ /_/_/ |_|\____/   
#
# ! BASHRC - CONFIGURATION FILE FOR BASH
# ! $HOME/.bashrc
# 
# Executed by BASH for non-login shells
# Loads $HOME/.bash_aliases
# Patched for macOS and BASH5
#
# version   0.6.4+
# author    aendeavor@Georg Lauterbach

###########################################################

# if not running interactively, don't do anything
check_on_interactive() {
  case $- in
      *i*) ;;
        *) exit;;
  esac
}

history_parameters() {
  HISTCONTROL=ignoreboth
  HISTSIZE=10000
  HISTFILESIZE=10000
}

shopts() {
  shopt -s histappend
  shopt -s checkwinsize
  shopt -s globstar
  shopt -s autocd
}

misc() {
  stty -ixon

  export VISUAL=nvim
  export EDITOR="$VISUAL"

  # more friendly less for non-text input files
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # colored GCC warnings and errors
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

  source ${HOME}/.config/alacritty/alacritty.bash
}

prompt() {
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='\[\e[38;5;72m\]'
    PS1+='[ \w ]'
  
    PS1+='\[\e[0m\] \$ '
  
    PROMPT_DIRTRIM=4
  else
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+='[\u@\h] : [ \w ] \$ '
  fi
}

aliases() {
  if [[ -f "${HOME}/.bash_aliases" ]]; then
      . "${HOME}/.bash_aliases"
  fi
}

programmable_completion() {
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
}

neofetch_parameterized() {
  neofetch\
    --ascii\
    --disable term uptime packages resolution theme icons cpu gpu wm de\
    --gtk3 on\
    --bar_border on\
    --underline_char \ \
    --block_range 0 7\
    --block_width 4\
    --block_height 1\
    --gap 13

  echo '' 
}

path() {
  PATH="$PATH:/Applications/Visual Studio \
  Code.app/Contents/Resources/app/bin"
  PATH="$PATH:/usr/local/Homebrew/bin"
  PATH="$PATH:${HOME}/.cargo/bin"

  PATH="$PATH:/usr/local/bin"
  PATH="$PATH:/usr/sbin"

  export PATH
}

main() {
  check_on_interactive  
  history_parameters
  shopts
  misc
  prompt
  aliases
  programmable_completion
  neofetch_parameterized
  path
}

main "$@"

