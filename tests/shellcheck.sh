#! /bin/bash

: '
# ? version       v0.1.0 RC1 PRODUCTION STABLE
# ? executed by   make
# ? task          checks scripts against shellcheck
'

# shellcheck source=../scripts/lib/errors.sh
. scripts/lib/errors.sh
# shellcheck source=../scripts/lib/logs.sh
. scripts/lib/logs.sh

export SCRIPT='SHELLCHECK'
LINT=(shellcheck -x -S style -Cauto -o all -e SC2154 -W 50)
ERR=0

# -->                   -->                   --> START

if ! command -v "${LINT[0]}" &>/dev/null
then
  __log_abort 'linter not in PATH'
  exit 1
fi

__log_info \
  'type: shellcheck' '(linter version:' \
  "$(${LINT[0]} --version | grep -m 2 -o "[0-9.]*"))"

# an overengineered solution to allow shellcheck -x to
# properly follow `source=<SOURCE FILE>` when sourcing
# files with `. <FILE>` in shell scripts.
while read -r FILE
do
  if ! (
  cd "$(realpath "$(dirname "$(readlink -f "${FILE}")")")"
  "${LINT[@]}" "$(basename -- "${FILE}")")
  then
  ERR=1
  fi
done < <(find . -type f -iname "*.sh")

if [[ ${ERR} -eq 0 ]]
then
  __log_success 'no errors detected'
else
  __log_abort 'errors encountered'
  exit 1
fi
