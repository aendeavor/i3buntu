#!/bin/bash

# ! HANDLES ISTALLATION OF FONT

sudo echo -e "\nThe script has begun!"

# ? Preconfig

##  directories (absolute & normalized) and files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # dir of this file
RES="$( readlink -m "${DIR}/../resources" )"                            # dir of resource folder
BACK="$(readlink -m "${DIR}/../backups/$(date '+%d-%m-%Y--%H-%M-%S')")" # dir of backup folder
LOG="${BACK}/.install_log"                                              # logfiles

backupInHome=( ~/.bash_aliases ~/.bashrc ~/.vimrc ~/.Xresources )
deployInHome=( bash/.bashrc bash/.bash_aliases vim/.vimrc vim/.viminfo X/.Xresources )
fonts=( 'fonts/Iosevka Nerd' 'fonts/Open Sans' 'fonts/Roboto' 'fonts/Roboto Mono Nerd' 'fonts/FontAwesome' )

##  init of backup-directory
mkdir -p "$BACK"

##  init of log
if [ ! -f "$LOG" ]; then
    touch "$LOG"
fi
WTL=( tee -a "${LOG}" )

##  rsync command with flags and options
RS=( rsync -avhz --delete )

# ? Preconfig finished
# ? Actual script begins

${RES}/others/IconTheme/install.sh - | ${WTL[@]}
