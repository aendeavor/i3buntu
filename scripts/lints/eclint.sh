#! /bin/bash

# version       v0.1.1-stable
# executed by   make
# task          linting EditorConfig

# shellcheck source=../lib/errors.sh
. scripts/lib/errors.sh
# shellcheck source=../lib/logs.sh
. scripts/lib/logs.sh

PATH="${CDIR}/tools:${PATH}"
export PATH

export SCRIPT='EditorConfig Linter'
LINT=(
  eclint
  -config
  scripts/tests/.ecrc.json
  -exclude
  "(\.git/.*|.*\.md|.*target/.*|\.lock|settings.json|LICENSE|tools/.*|i3buntu|\.tar\.xz)"
)

# -->                   -->                   --> START

if ! command -v "${LINT[0]}" &>/dev/null
then
  __log_abort 'linter not in PATH'
  exit 1
fi

__log_info "version: $(${LINT[0]} --version)"

if "${LINT[@]}"
then
  __log_success 'no errors detected'
else
  __log_abort 'errors encountered'
  exit 1
fi
