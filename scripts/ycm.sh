#! /usr/bin/env bash

# version       0.2.0 RC1 BETA1 UNSTABLE
# executed      manually
# task          compiles NeoVim-YouCompleteMe plugin and
#               copies .ycm_extra_conf.py

# shellcheck source=./lib/errors.sh
. ./lib/errors.sh

# pip3 install pynvim

cd "${HOME}/.config/nvim/plugged/YouCompleteMe"

wget SOME_URL/.ycm_extra_conf.py

python3 install.py \
  --rust-completer \
  --clang-completer \
  --clang-tidy
