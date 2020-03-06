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
#
# version   0.6.4
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

  export VISUAL=vim
  export EDITOR="$VISUAL"

  # more friendly less for non-text input files
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # colored GCC warnings and errors
  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
}

prompt() {
  # set variable identifying chroot you work in
  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
  fi
  
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    PS1='${debian_chroot:+($debian_chroot)}'
  
    PS1+='\[\e[38;5;110m\]'
    PS1+='[\u@\h]'
  
    PS1+='\[\e[0m\] : '
  
    PS1+='\[\e[38;5;110m\]'
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
    --disable term uptime packages resolution theme icons cpu gpu\
    --gtk3 on\
    --bar_border on\
    --ascii_distro arch --underline_char \ \
    --block_range 0 7\
    --block_width 4\
    --block_height 1\
    --gap 13

  echo '' 
}

update_ps1() {
  PS1="$(/bin/powerline-go-linux-amd64\
    -error $?\
    -numeric-exit-codes\
    -cwd-max-depth 7\
    -cwd-max-dir-size 11\
    -modules "ssh,cwd,git,hg,jobs,exit,root"\
  )"
}

powerline() {
  if [ "$TERM" != "linux" ] && [ -f "/bin/powerline-go-linux-amd64" ]; then
    PROMPT_COMMAND="update_ps1; $PROMPT_COMMAND"
  fi
}

main() {
  check_on_interactive  
  history_parameters
  shopts
  prompt
  aliases
  programmable_completion
  neofetch_parameterized
  #powerline
}

main "$@" || exit 1
