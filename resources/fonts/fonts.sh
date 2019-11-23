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

echo -e "\t->FiraCode will be installed..."
./firacode.sh 

echo -e "\t->FontAwesome is next..."
./fontawesome.sh

echo -e "\t->Iosevka is next..."
./iosevkanerd.sh

echo -e "\t->Roboto Mono Nerd is next..."
./robotomononerd.sh

echo -e "\t->Fonts installed."

# ? Actual script finished
