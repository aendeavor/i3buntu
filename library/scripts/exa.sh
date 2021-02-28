#! /usr/bin/env bash

# version       0.2.2-stable
# executed      manually
# task          installs EXA with Cargo to replace ls

# shellcheck source=../../scripts/lib/errors.sh
. ../../scripts/lib/errors.sh
# shellcheck source=../../scripts/lib/logs.sh
. ../../scripts/lib/logs.sh

if ! command -v cargo &>/dev/null
then
  __log_abort 'Cargo is not installed or in PATH'
  exit 1
fi

cargo install exa

if [[ -e "${HOME}/.bash_aliases" ]]
then
  sed -i "s/alias ls='ls -lh --color=auto'/\
alias ls='exa --binary --header \
--long --group --git'/g" "${HOME}/.bash_aliases"
  sed -i "s/alias lsa='ls -lhA --color=auto'/\
alias lsa='exa -b -h -l -g --git -a'/g" \
"${HOME}/.bash_aliases"
fi
