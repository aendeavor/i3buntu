#! /bin/bash

: '
# ? version       v0.1.0 RC1 BETA1 UNSTABLE
# ? sourced by    shell scripts under scripts/
# ? task          provides error handlers
'

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
