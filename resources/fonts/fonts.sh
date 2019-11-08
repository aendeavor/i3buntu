#!/bin/bash

# This script serves as a wrapper for
# the installation of all fonts in the
# directory of this script.
# 
# current version - 0.0.1

# ? Preconfig

LOG="$1"

# ? Preconfig finished
# ? Actual script begins

echo -e "FiraCode will be installed..."
./firacode.sh >> $LOG

echo -e "Finished installing FiraCode! FontAwesome is next..."
./fontawesome.sh >> $LOG

echo -e "Finished installing FontAwesome! Iosevka is next..."
./iosevkanerd.sh >> $LOG

echo -e "Finished installing Iosevka! Roboto Mono Nerd is next..."
./robotomononerd.sh >> $LOG

echo -e "Finished installing Roboto Mono Nerd! Fonts installed."

# ? Actual script finished
