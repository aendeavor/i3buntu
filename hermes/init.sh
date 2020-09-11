#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.2.0 stable

set -euE
trap '_log_err ${_} ${LINENO} ${?}' ERR

function _log_err()
{
  echo -e "ERROR occured :: source ${1} ; line ${2} ; exit code ${3}"
}

function _main()
{
  local _release="2.1.0-stable"
  local _archive="v${_release}.tar.gz"

  if [[ -e "${_archive}" ]] || [[ -d "i3buntu-${_release}" ]]
  then
    printf '%s %s %s %s %s\n' \
      'There is already a file named' \
      "${_archive}" \
      "or a directory called" \
      "${_release}" \
      'in this directory. Aborting.'
    return 10
  fi

  local _gh='https://github.com/'
  local _user="${_gh}aendeavor/i3buntu/archive"

  if ! wget "${_user}/${_archive}" &>/dev/null
  then
    printf '%s %s\n' \
      'Could not download repository.' \
      'Aborting.'
    return 100
  fi

  tar -xzf "${_archive}" &>/dev/null
  cd "i3buntu-${_release}" || return 200

  ./apollo </dev/tty
}

_main || exit ${?}
