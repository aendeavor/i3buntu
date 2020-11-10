#! /usr/bin/env bash

# Compiles NeoVim's YouCompleteMe plugin and
# copies `.ycm_extra_conf.py`.
# 
# author   Georg Lauterbach
# version  0.2.0 unstable

set -euo pipefail
trap '_log_err ${_} ${LINENO} ${?}' ERR

function _log_err()
{
  echo -e "ERROR occured :: source ${1} ; line ${2} ; exit code ${3}"
  unset SD COMPLETER RHOME RPATH
}

SD=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
COMPLETER=(--rust-completer --clang-completer --clang-tidy)

cd "${HOME}/.config/nvim/plugged/YouCompleteMe"
python3 install.py "${COMPLETER[@]}"
	
RHOME="/../resources/config/home/"
RPATH=".config/nvim/.ycm_extra_conf.py"

cp "$(readlink -m "${SD}${RHOME}${RPATH}")" .

unset SD COMPLETER RHOME RPATH
