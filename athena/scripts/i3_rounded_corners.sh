#!/bin/bash

# Upgrades i3-gaps in-place to support rounded corners.

# author    aendeavor@Georg Lauterbach
# version   0.1.0
# source    https://en.terminalroot.com.br/how-to-install-i3-gaps-with-rounded-corners/

function main() {
  cd /tmp || return 1
  [[ -d i3-radius ]] || git clone https://github.com/terroo/i3-radius
  cd i3-radius || return 1
  grep -q "\-\-prefix=/usr/local" build.sh || sed -i "s/--prefix=\/usr/--prefix=\/usr\/local/g" build.sh
  sh build.sh
}

main "$@" || exit 1

