#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.0.1

# ? Preconfig

LOG="$1"
WTL=( tee -a "$LOG" )

# ? Preconfig finished
# ? Actual script begins

echo -e "\t->FiraCode will be installed..."
./firacode.sh 

printf "\tfinished.\n\t->FontAwesome is next..."
./fontawesome.sh

printf "\tfinished.\n\t->Iosevka is next..."
./iosevkanerd.sh

printf "\tfinished.\n\t->Roboto Mono Nerd is next..."
./robotomononerd.sh

printf "\tfinished.\n\t->Fonts installed."

# ? Actual script finished
