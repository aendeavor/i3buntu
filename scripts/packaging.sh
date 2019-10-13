#!/bin/bash

# ! UNFINISHED

# ! WRAPPER SCRIPT FOR INITIAL INSTALLATION

sudo echo -e "\nInitial installation has begun!"

# ? Preconfig

##  directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../backups/packageInstallation/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/.install_log"

##  init of backup-directory
if [ ! -d "$BACK" ]; then
    mkdir -p "$BACK"
fi

##  init of log
if [ ! -f "$LOG" ]; then
    touch "$LOG"
fi
WTL=( tee -a "$LOG" )

sudo apt-get -qq -y update


# ? Preconfig finished
# ? Actual script begins

echo -e "Started at: $(date)" | ${WTL[@]}

# ! Actual installing script
${DIR}/installPackages.sh | ${WTL[@]}

# ? Reboot after everything finished