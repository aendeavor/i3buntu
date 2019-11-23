#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.2.0

# ? Preconfig

LOG="$1"
WTL=( tee -a "$LOG" )

# ? Preconfig finished
# ? Actual script begins

echo -e "\t\t->FiraCode will be installed..."
./firacode.sh 

printf "\t\t->FontAwesome is next..."
./fontawesome.sh

printf "\t\t->Iosevka is next..."
./iosevkanerd.sh

printf "\t\t->Roboto Mono Nerd is next..."
./robotomononerd.sh

printf "\t->Fonts installed."

# ? Actual script finished
