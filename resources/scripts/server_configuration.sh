#!/bin/bash

# This script serves as the main post-packaging
# script for server installations, i.e. it
# backups existing config files and deploys new
# and correct version from this repository.
# This sctipt is not executed by hand, but rather
# by the sever_packaging.sh script after it has
# run.
# 
# current version - 0.6.2

sudo printf ""

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../../backups/configuration/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/configuration_log"

RS=( rsync -ahq --delete )

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
BLU='\033[1;34m'    # BLUE
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}\t"
WAR="${YEL}WARNING${NC}\t"
SUC="${GRE}SUCCESS${NC}\t"
INF="${BLU}INFO${NC}\t"

## init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

## init of logfile
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG" ]]; then
        &>/dev/null sudo rm $LOG
    fi
    touch "$LOG"
fi
WTL=( tee -a "$LOG" )

# ? Preconfig finished
# ? Actual script begins

## backup of configuration files
sudo echo -e "${INF}Configuration has begun!\n${INF}Started at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Checkig for existing files\n" | ${WTL[@]}

HOME_FILES=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" )
for FILE in ${HOME_FILES[@]}; do
    if [[ -f "$FILE" ]]; then
        backupFile="${BACK}${FILE#~}.bak"
        echo -e "-> Found ${FILE}\n\tBacking up to ${backupFile}" | ${WTL[@]}
        >/dev/null 2>>"${LOG}" sudo ${RS[@]} "$FILE" "$backupFile"
    fi
done

if [[ -d "${HOME}/.vim" ]]; then
    echo -e "-> Found ~/.vim directory!\n\tBacking up to ${BACK}/.vim" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.vim" "${BACK}"
    rm -rf "${HOME}/.vim"
fi

if [ -d "${HOME}/.config" ]; then
    echo -e "-> Found ~/.config directory!\n\tBacking up to ${BACK}/.config" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.config/i3" "${BACK}"
fi

## deployment of configuration files
echo -e "\nProceeding to deploying config files:" | ${WTL[@]}

DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
done

echo -e "${SUC}Finished with the actual script" | ${WTL[@]}

# ? Actual script finished
# ? Postconfiguration and restart

echo -e "\n${INF}The script has finished!\n${INF}Ended at: $(date '+%d.%m.%Y-%H:%M')\n" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like to restart? [Y/n]" -r RESTART
if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
    shutdown -r now
fi
