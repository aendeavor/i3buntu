#! /bin/bash

# pip3 install pynvim

cd "${HOME}/.config/nvim/plugged/YouCompleteMe" || exit 1

wget \
  https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/config/home/.config/nvim/.ycm_extra_conf.py

python3 install.py --rust-completer --clang-completer --clang-tidy

