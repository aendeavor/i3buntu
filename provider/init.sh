#!/bin/bash

: '
# ? version       v0.2.0 RC1 BETA1 UNSTABLE
# ? executed by   curl | bash
# ? task          Downloads application & starts installation
'

# -->                   -->                   --> ERRORS

set -euEo pipefail

trap '__log_uerror ${FUNCNAME[0]:-'?'} ${_:-'?'} ${LINENO:-'?'} ${?:-'?'}' ERR

function __log_uerror
{
  local FUNC_NAME LINE EXIT_CODE
  
  FUNC_NAME="${1} / ${2}"
  LINE="${3}"
  EXIT_CODE="${4}"

  printf "\n––– \e[1m\e[31mUNCHECKED ERROR\e[0m\n%s\n%s\n%s\n%s\n\n" \
    "  – script    = ${SCRIPT:-'SCRIPT unknown'}" \
    "  – function  = ${FUNC_NAME}" \
    "  – line      = ${LINE}" \
    "  – exit code = ${EXIT_CODE}"
}

# -->                   -->                   --> START

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

  local GH='https://github.com/'
  local USER="${GH}aendeavor/i3buntu/archive"

  if ! wget "${USER}/${ARCHIVE}" &>/dev/null
  then
    printf '%s %s\n' \
      'Could not download repository.' \
      'Aborting.'
    return 100
  fi

  tar -xzf "${ARCHIVE}" &>/dev/null
  cd "i3buntu-${RELEASE}" || return 200

  ./app </dev/tty
}

_main || exit ${?}
