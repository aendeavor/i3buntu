#! /bin/bash

: '
# ? version       v0.1.0 RC1 PRODUCTION STABLE
# ? sourced by    shell scripts under scripts/
# ? task          provides logging functionality
'

function __log_info
{
  printf "\n––– \e[34m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-'SCRIPT unknown'}" \
    "  – type    = INFO" \
    "  – message = ${*}"
}

function __log_warning
{
  printf "\n––– \e[93m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-'SCRIPT unknown'}" \
    "  – type    = WARNING" \
    "  – message = ${*}"
}

function __log_abort
{
  printf "\n––– \e[91m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-'SCRIPT unknown'}" \
    "  – type    = ABORT" \
    "  – message = ${*}"
}

function __log_success
{
  printf "\n––– \e[32m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-'SCRIPT unknown'}" \
    "  – type    = SUCCESS" \
    "  – message = ${*}"
}
