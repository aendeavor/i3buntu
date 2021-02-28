#! /bin/bash

# version       v0.1.2-stable
# sourced by    shell scripts under scripts/
# task          provides error handlers

set -euEo pipefail

trap '__log_uerror "${FUNCNAME[0]:-?}" "${BASH_COMMAND:-?}" "${LINENO:-?}" "${?:-?}"' ERR

function __log_uerror
{
  printf "\n––– \e[1m\e[31mUNCHECKED ERROR\e[0m\n%s\n%s\n%s\n%s\n\n" \
  "  – script    = ${SCRIPT:-${0}}" \
  "  – function  = ${1} / ${2}" \
  "  – line      = ${3}" \
  "  – exit code = ${4}" >&2
}
