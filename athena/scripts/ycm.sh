#!/usr/bin/env bash

# Compiles NeoVim's YouCompleteMe plugin and
# copies `.ycm_extra_conf.py`.
# 
# author   Georg Lauterbach
# version  0.1.5 stable

set -eE
trap 'exit 2' ERR

SD=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)

function main()
{
	trap '' SIGTERM SIGINT

	cd "${HOME}/.config/nvim/plugged/YouCompleteMe"
    local _completer=(
      --rust-completer
      --clang-completer
      --clang-tidy
    )

	python3 install.py "${_completer[@]}"
	
	local _rhome="/../resources/config/home/"
	local _rpath=".config/nvim/.ycm_extra_conf.py"
	cp "$(readlink -m "${SD}${_rhome}${_rpath}")" .
}

main || exit 1
