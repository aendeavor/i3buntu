#!/usr/bin/env bash

# Compiles NeoVim's YouCompleteMe plugin and
# copies `.ycm_extra_conf.py`.

# author    Georg Lauterbach
# version   0.1.1 unstable

set -e

sudo apt-get -y install python3-dev build-essential clang-tidy

_path="${HOME}/.config/nvim/plugged/YouCompleteMe"

cd "${_path}"
python3 install.py --rust-completer --clang-completer --clang-tidy

cp "$(readlink -m "$(pwd)/../config/home/.config/nvim/.ymc_extra_conf.py")" .

