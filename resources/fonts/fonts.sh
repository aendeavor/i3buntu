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

echo -e "FiraCode will be installed..." | ${WTL[@]}
>/dev/null 2>>"${LOG}" ./firacode.sh

echo -e "Finished installing FiraCode! FontAwesome is next..." | ${WTL[@]}
>/dev/null 2>>"${LOG}" ./fontawesome.sh

echo -e "Finished installing FontAwesome! Iosevka is next..." | ${WTL[@]}
>/dev/null 2>>"${LOG}" ./iosevkanerd.sh

echo -e "Finished installing Iosevka! Roboto Mono Nerd is next..." | ${WTL[@]}
>/dev/null 2>>"${LOG}" ./robotomononerd.sh

echo -e "Finished installing Roboto Mono Nerd! Fonts installed." | ${WTL[@]}

# ? Actual script finished
