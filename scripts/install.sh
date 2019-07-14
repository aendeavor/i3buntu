#!/bin/bash

# ! WRAPPER SCRIPT FOR INITIAL PACKAGE INSTALLATION

sudo echo -e "\nThe script has begun!"

# ? Preconfig

##  directories (absolute & normalized) and files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"                     # dir of this file
BACK="$(readlink -m "${DIR}/../backups/packageInstallation/$(date '+%d-%m-%Y--%H-%M-%S')")" # dir of backup folder
LOG="${BACK}/.install_log"

##  init of backup-directory
if [ ! -d "$BACK" ]; then
    mkdir -p "$BACK"
fi

##  init of log
if [ ! -f "$LOG" ]; then
    touch "$LOG"
fi
WTL=( tee -a "${LOG}" )

# ? Preconfig finished
# ? Actual script begins

echo -e "Started at: $(date)" | ${writeToLog[@]}

# ! Actual installing script
./installPackages.sh | ${writeToLog[@]}
