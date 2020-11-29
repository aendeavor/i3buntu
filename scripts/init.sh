#! /bin/bash

: '
# ? version       v0.4.1 RC1 BETA1 UNSTABLE
# ? executed by   curl | bash
# ? task          Downloads application & starts installation
'

# -->                   -->                   --> ERRORS

set -euEo pipefail

trap 'unset RELEASE ARCHIVE GH' EXIT
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

# -->                   -->                   --> INTEGRITY CHECK

function __check_integrity
{
  local SHA_SUMS_FILE GREP_CMD SHA1SUM SHA256SUM SHA512SUM
  
  SHA_SUMS_FILE="$(curl --tlsv1.2 -sSf https://raw.githubusercontent.com/aendeavor/i3buntu/master/.env)"
  SELF="$(curl --tlsv1.2 -sSfL i3buntu.itbsd.com)"

  GREP_CMD=(grep -a -m 1 -h -o -E "[0-9a-zA-Z]+")
  SHA1SUM="$(sha1sum <<< "${SELF}" | "${GREP_CMD[@]}" | head -1)"
  SHA256SUM="$(sha256sum <<< "${SELF}" | "${GREP_CMD[@]}" | head -1)"
  SHA512SUM="$(sha512sum <<< "${SELF}" | "${GREP_CMD[@]}" | head -1)"

  if ! grep -q "${SHA1SUM}" <<< "${SHA_SUMS_FILE}" || \
  ! grep -q "${SHA256SUM}" <<< "${SHA_SUMS_FILE}" || \
  ! grep -q "${SHA512SUM}" <<< "${SHA_SUMS_FILE}"
  then
  echo "Checksums are not matching. Aborting." >&2
  exit 1
  fi
}

__check_integrity

# -->                   -->                   --> START

RELEASE="3.2.0-stable"
ARCHIVE="v${RELEASE}.tar.gz"
GH="https://github.com/aendeavor/i3buntu/archive"

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


if ! wget "${GH}/${ARCHIVE}" &>/dev/null
then
  printf '%s %s\n' \
  'Could not download repository.' \
  'Aborting.'
  return 100
fi

tar -xzf "${ARCHIVE}" &>/dev/null
cd "i3buntu-${RELEASE}" || return 200

./i3buntu </dev/tty
