#!/bin/bash

# ! WRAPPER SCRIPT FOR INITIAL INSTALLATION / PACKAGING

sudo echo -e "\nInstallation has begun!"

# ? Preconfig

##  directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../backups/packageInstallation/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/.install_log"

##  init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

##  init of log
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG"]]; then
        sudo rm $LOG
    fi
    touch "$LOG"
fi
WTL=( tee -a "$LOG" )

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

EXEC="${DIR}/../resources/scripts/packaging.sh"
if [[ ! -x "$EXEC" ]]; then
    sudo chmod +x $EXEC
fi

# ? Preconfig finished
# ? Actual script begins

echo -e "Started at: $(date)" | ${WTL[@]}
$EXEC | ${WTL[@]}

# ? Actual script finished
# ? Postconfiguration and restart

echo -e "The script has finished!\nEnded at: $(date)" | ${WTL[@]}

echo -ne "Restart in..."
for I in {5..1..-1}; do
    echo -ne "\rRestart in "
    echo -en "$I seconds!"
    sleep 1
done
sudo shutdown -r now
