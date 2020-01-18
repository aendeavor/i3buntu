#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.3.0 unstable

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# initiate aliases and functions
. "${DIR}/../sys/sh/.bash_aliases"

# ? Preconfig finished
# ? Actual script begins

inform 'FiraCode will be installed...'
./firacode.sh 
if (( $? == 0 )); then
    succ 'FiraCode successfully installed'
else
    err 'FiraCode not successfully installed'
fi

inform 'FontAwesome is next...'
./fontawesome.sh
if (( $? == 0 )); then
    succ 'FontAwesome successfully installed'
else
    err 'FontAwesome not successfully installed'
fi

inform 'Iosevka is next...'
./iosevkanerd.sh
if (( $? == 0 )); then
    succ 'Iosevka successfully installed'
else
    err 'Iosevka not successfully installed'
fi

inform 'Roboto Mono Nerd is next...'
./robotomononerd.sh
if (( $? == 0 )); then
    succ 'Roboto Mono Nerd successfully installed'
else
    err 'Roboto Mono Nerd not successfully installed'
fi

succ 'Fonts installed'

# ? Actual script finished
