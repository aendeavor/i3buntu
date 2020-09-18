#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.2.3 stable

set -euEo pipefail
trap '_log_err ${_} ${LINENO} ${?}' ERR

function _log_err()
{
  echo -e "ERROR occured :: source ${1} ; line ${2} ; exit code ${3}"
}

function _main()
{
  local RELEASE="2.1.0-stable"
  local ARCHIVE="v${RELEASE}.tar.gz"

  if [[ -e ${ARCHIVE} ]] || [[ -d "i3buntu-${RELEASE}" ]]
  then
    printf '%s %s %s %s %s\n' \
      'There is already a file named' \
      "${ARCHIVE}" \
      "or a directory called" \
      "${RELEASE}" \
      'in this directory. Aborting.'
    return 10
  fi

  local _gh='https://github.com/'
  local _user="${_gh}aendeavor/i3buntu/archive"

  if ! wget "${_user}/${ARCHIVE}" &>/dev/null
  then
    printf '%s %s\n' \
      'Could not download repository.' \
      'Aborting.'
    return 100
  fi

  tar -xzf "${ARCHIVE}" &>/dev/null
  cd "i3buntu-${RELEASE}" || return 200

  ./apollo </dev/tty
}

_main || exit ${?}
