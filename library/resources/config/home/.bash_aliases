#!/bin/bash
#        ____  ___   _____ __  __     ___    __    _______   _____ ___________
#       / __ )/   | / ___// / / /    /   |  / /   /  _/   | / ___// ____/ ___/
#      / __  / /| | \__ \/ /_/ /    / /| | / /    / // /| | \__ \/ __/  \__ \ 
#   _ / /_/ / ___ |___/ / __  /    / ___ |/ /____/ // ___ |___/ / /___ ___/ / 
#  (_)_____/_/  |_/____/_/ /_/____/_/  |_/_____/___/_/  |_/____/_____//____/  
#                           /_____/
#
# ! BASH_ALIASES - ADDITIONAL CONFIGURATION FILE FOR BASH
# ! $HOME/.bash_aliases
#
# version   1.3.1
# author    Georg Lauterbach
# executed  from $HOME/.bashrc
#
# shellcheck disable=SC2024
#
#################################################

if [[ ! -x /usr/bin/dircolors ]] || [[ ! -r ${HOME}/.dircolors ]] || ! eval "$(dircolors -b "${HOME}/.dircolors")"
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
alias vmp='sudo vmplayer &>/dev/null &'

alias v='nvim'
alias sv='sudo nvim'

alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ? ––––––––––––––––––––––––––––––––––––––––––––– Functions

function dt     { printf "%s " "$(date '+%H:%M:%S')"          ; }
function inform { echo -e "$(dt)\033[1;34mINFO\033[0m\t\t$1"  ; }
function err    { echo -e "$(dt)\033[0;31mERROR\033[0m\t\t$1" ; }
function warn   { echo -e "$(dt)\033[1;33mWARNING\033[0m\t$1" ; }
function succ   { echo -e "$(dt)\033[1;32mSUCCESS\033[0m\t$1" ; }

function sf()
{
  local SEARCH=${1:?Enter a search-regex}
  local MAXDEPTH=${2:-1}
  local TYPE=${3:-}

  find . -maxdepth "${MAXDEPTH}" -iname "*${SEARCH}*" "${TYPE}"
}
export -f sf

function shutn { shutdown now ; }
export -f shutn

function update()
{
  if ! sudo -AE printf '' &>/dev/null && ! sudo -E printf ''
  then
    echo '' ; err 'User input invalid. Aborting.' ; return 1
  fi

  local ERR=0
  local LOG="${HOME}/.update_log"
  echo '' >"${LOG}"

  local OPTIONS=(
    --yes
    --assume-yes
    --allow-unauthenticated
    --allow-change-held-packages
  )

  warn 'New update started'
  inform 'Checking for updates'

  if ! sudo apt-get update &>>"${LOG}"
  then
    err "Could'nt update APT signatures [${?}]" ; return 1
  fi

  inform 'Installing updates'
  if ! sudo apt-get --with-new-pkgs "${OPTIONS[@]}" upgrade &>>"${LOG}"
  then
    err "APT upgrade exited with an error [${?}]" ; return 1
  fi

  inform 'Removing orphaned packages'
  if ! sudo apt-get "${OPTIONS[@]}" autoremove &>>"${LOG}"
  then
    err "APT autoremove exited with an error [${?}]" ; ERR=1
  fi

  if [[ -n $(command -v snap) ]]
  then
    inform 'Updating via SNAP'
    if ! sudo snap refresh &>>"${LOG}"
    then
      err "Could not refresh snaps [${?}]" ; ERR=1
    fi
  fi

  if [[ -n $(command -v rustup) ]]
  then
    inform 'Updating RUST via rustup'
    if ! rustup update &>>"${LOG}"
    then
      err "sudo apt-get update returned with error code $RIP" ; ERR=1
    fi
  fi

  if [[ $ERR -eq 0 ]]
  then
    succ 'Completed update'
  else
    warn 'Completed update with errors'
  fi
}
export -f update
