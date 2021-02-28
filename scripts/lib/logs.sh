#! /bin/bash

# version       v0.1.3-stable
# sourced by    shell scripts under scripts/
# task          provides logging functionality

function __log_info
{
  printf "\n––– \e[34m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-${0}}" \
    "  – type    = INFO" \
    "  – message = ${*}"
}

function __log_warning
{
  printf "\n––– \e[93m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-${0}}" \
    "  – type    = WARNING" \
    "  – message = ${*}" >&2
}

function __log_abort
{
  printf "\n––– \e[31m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-${0}}" \
    "  – type    = ABORT" \
    "  – message = ${*}" >&2
}

function __log_failure
{
  printf "\n––– \e[91m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-${0}}" \
    "  – type    = FAILURE" \
    "  – message = ${*}" >&2
}

function __log_success
{
  printf "\n––– \e[32m%s\e[0m\n%s\n%s\n\n" \
    "${SCRIPT:-${0}}" \
    "  – type    = SUCCESS" \
    "  – message = ${*}"
}
