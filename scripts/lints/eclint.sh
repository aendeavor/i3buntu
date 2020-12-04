#! /bin/bash

: '
# ? version       v0.1.2 RC1 PRODUCTION STABLE
# ? executed by   just
# ? task          checks scripts against an editorconfig linter
'

# shellcheck source=../lib/errors.sh
. scripts/lib/errors.sh
# shellcheck source=../lib/logs.sh
. scripts/lib/logs.sh

export SCRIPT='EDITORCONFIG LINTER'
LINT=(eclint -exclude "(.*\.git.*|.*\.md$|.*target\/.*|\.lock$)")

# -->                   -->                   --> START

if ! command -v "${LINT[0]}" &>/dev/null
then
  __log_abort 'linter not in PATH'
  exit 1
fi

__log_info \
  'type: editorconfig' \
  '(linter version:' "$(${LINT[0]} --version))"

if "${LINT[@]}"
then
  __log_success 'no errors detected'
else
  __log_failure 'errors encountered'
  exit 1
fi
