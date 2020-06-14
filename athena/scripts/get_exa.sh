#!/bin/bash

# installs exa with Cargo
# to replace the 'ls' command
#
# version 0.1.0

function main() {
  [[ -n $(command -v cargo) ]] || { echo "Cargo is not installed. Install RUST and Cargo first. Aborting."; exit 1; }
  cargo install exa

  sed -i "s/alias ls='ls -lh --color=auto'/alias ls='exa --binary --header --long --group --git'/g" "${HOME}/.bash_aliases"
  sed -i "s/alias lsa='ls -lhA --color=auto'/alias lsa='exa -b -h -l -g --git -a'/g" "${HOME}/.bash_aliases"

  echo "Success"
}

main "$@" || exit 1
