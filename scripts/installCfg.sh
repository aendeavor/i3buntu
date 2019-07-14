#!/bin/bash

# ! HANDLES INSERTION OF RESOURCE FILES

sudo echo -e "\nThe script has begun!"

# ? Preconfig

##  directories (absolute & normalized) and files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # dir of this file
RES="$( readlink -m "${DIR}/../resources" )"                            # dir of resource folder
BACK="$(readlink -m "${DIR}/../backups/$(date '+%d-%m-%Y--%H-%M-%S')")" # dir of backup folder
LOG="${BACK}/.install_log"                                              # logfiles

backupInHome=( ~/.bash_aliases ~/.bashrc ~/.vimrc ~/.Xresources )
deployInHome=( bash/.bashrc bash/.bash_aliases vim/.vim vim/.vimrc vim/.viminfo X/.Xresources )
fonts=( 'fonts/Iosevka Nerd' 'fonts/Open Sans' 'fonts/Roboto' 'fonts/Roboto Mono Nerd' )

##  init of backup-directory
if [ ! -d "$BACK" ]; then
    mkdir -p "$BACK"
fi

##  init of log
if [ ! -f "$LOG" ]; then
    touch "$LOG"
fi
WTL=( tee -a "${LOG}" )

##  rsync command with flags and options
RS=( rsync -avhz --delete )

# ? Preconfig finished
# ? Actual script begins

echo -e "Checking for existing files...\n" | ${WTL[@]}

# ? Backup

##  files that could be backed-up
for file in ${backupInHome[@]}; do
    (
        if [ -f "$file" ]; then
            backupFile="${BACK}${file#~}.bak"
            echo -e "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${WTL[@]}
            ${RS[@]} "$file" "$backupFile" >> $LOG
        fi
    )
done

##  .vim directory files
if [ -d ~/.vim ]; then
    echo -e "   -> Found ~/.vim directory!\n         Backing up to ${BACK}/.vim\n" | ${WTL[@]}
    ${RS[@]} ~/.vim ${BACK} >> $LOG
    rm -rf ~/.vim
fi

##  i3 config files
if [ -d ~/.config/i3 ]; then
    echo -e "   -> Found ~/.config/i3 directory\n         Backing up to ${BACK}/i3\n" | ${WTL[@]}
    mkdir "${BACK}/i3"
    ${RS[@]} ~/.config/i3/ "${BACK}/i3" >> $LOG
fi

# ? Deployment

echo -e "Proceeding to deploying config files..." | ${WTL[@]}

## deploy to $HOME
for sourceFile in "${deployInHome[@]}"; do
    (
        echo -e "   -> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
        ${RS[@]} "${RES}/${sourceFile}" ~ >> $LOG
    )
done

##  i3
mkdir -p ~/.config/i3
${RS[@]} "${RES}/X/i3config/" ~/.config/i3 >> $LOG

##  fonts
mkdir -p ~/.fonts
rsync -a "${RES}/resources/fonts/" ~/.fonts >> $LOG

##  wallpapers
mkdir -p ~/pictures
${RS[@]} "${RES}/wallpapers" ~/pictures >> $LOG

# ? Reload of services and caches

fc-cache ## fonts
xrdb ~/.Xresources

# ? User's choices

echo ""
read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r responseTwo
if [[ $responseTwo =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $responseTwo ]]; then
    sudo rm -f /etc/default/grub
    sudo cp ${RES}/others/grub /etc/default/
fi

# ? Actual script finished
 
echo -e "\nDeployment of configuration files has ended. Installation finished!\nPlease open a new shell for changes to take effect." | ${WTL[@]}
 