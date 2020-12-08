#! /usr/bin/env bash

: '
# ? version       0.2.0 RC1 BETA1 UNSTABLE
# ? executed      manually
# ? task          compiles NeoVim-YouCompleteMe plugin and
# ?               copies .ycm_extra_conf.py
'

# shellcheck source=../../scripts/lib/errors.sh
. ../../scripts/lib/errors.sh

SD=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
COMPLETER=(--rust-completer --clang-completer --clang-tidy)

cd "${HOME}/.config/nvim/plugged/YouCompleteMe"
python3 install.py "${COMPLETER[@]}"
  
RHOME="/../resources/config/home/"
RPATH=".config/nvim/.ycm_extra_conf.py"

cp "$(readlink -m "${SD}${RHOME}${RPATH}")" .

unset SD COMPLETER RHOME RPATH
