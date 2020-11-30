#! /bin/bash

: '
# ? version       v0.5.0 RC1 BETA2 UNSTABLE
# ? executed by   curl | bash
# ? task          starts installation
'

# -->                   -->                   --> ERRORS

set -euEo pipefail
trap '__log_uerror ${FUNCNAME[0]:-'?'} ${_:-'?'} ${LINENO:-'?'} ${?:-'?'}' ERR

function __log_uerror
{
  printf "\n––– \e[1m\e[31mUNCHECKED ERROR\e[0m\n%s\n%s\n%s\n%s\n\n" \
    "  – script    = init.sh" \
    "  – function  = ${1} / ${2}" \
    "  – line      = ${3}" \
    "  – exit code = ${4}"
}

# -->                   -->                   --> INTEGRITY CHECK

function _check_integrity
{
  local START SHA_SUMS_FILE
  START="$(declare -f _start)"
  SHA_SUMS_FILE="$(curl --tlsv1.2 -sSf https://raw.githubusercontent.com/aendeavor/i3buntu/master/.env)"
  
  if  ! grep -q "$(sha512sum <<< "${START}")" <<< "${SHA_SUMS_FILE}" || \
      ! grep -q "$(sha256sum <<< "${START}")" <<< "${SHA_SUMS_FILE}" || \
      ! grep -q "$(sha1sum <<< "${START}")" <<< "${SHA_SUMS_FILE}"
  then
    echo "Checksums are not matching. Aborting." >&2
    exit 1
  fi
}

# -->                   -->                   --> START

function _start
{
  local RELEASE="3.2.0-stable"
  local ARCHIVE="v${RELEASE}.tar.gz"
  local GH="https://github.com/aendeavor/i3buntu/archive"

  if [[ -e ${ARCHIVE} ]] || [[ -d "i3buntu-${RELEASE}" ]]
  then
    echo "There is already a file named ${ARCHIVE} or a directory called ${RELEASE} in this directory. Aborting." >&2
    exit 1
  fi

  if ! wget "${GH}/${ARCHIVE}" &>/dev/null
  then
    printf '%s %s\n' \
    'Could not download repository.' \
    'Aborting.'
    return 100
  fi

  tar -xzf "${ARCHIVE}" &>/dev/null
  cd "i3buntu-${RELEASE}"

  ./i3buntu < /dev/tty
}

if [[ ${1:-''} == '--sha' ]]
then
  sha1sum <<< "$(declare -f _start)"
  sha256sum <<< "$(declare -f _start)"
  sha512sum <<< "$(declare -f _start)"
else
  _check_integrity
  _start
fi
