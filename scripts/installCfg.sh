#!/bin/bash

# ! HANDLES INSERTION OF RESOURCE FILES

# ? Preconfig

##  directories (absolute & normalized) and files
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # dir of this file
RES="$( readlink -m "${DIR}/../resources" )"                            # dir of resource folder
BACK="$(readlink -m "${DIR}/../backups/$(date '+%d-%m-%Y--%H-%M-%S')")" # dir of backup folder
LOG="${DIR}/.install_log"                                               # logfiles

backupInHome=( ~/.bash_aliases ~/.bashrc ~/.vimrc ~/.Xresources )
deployInHome=( bash/.bashrc bash/.bash_aliases vim/.vim vim/.vimrc vim/.viminfo X/.Xresources )
fonts=( 'fonts/Iosevka Nerd' 'fonts/Open Sans' 'fonts/Roboto' 'fonts/Roboto Mono Nerd' )

##  init of log
if [ ! -f "$LOG" ]; then
    sudo touch "${LOG}"
fi
WTL=( tee -a "${LOG}" )

##  init of backup-directory
if [ ! -d "$BACK" ]; then
    mkdir -p "$BACK"
fi

##  rsync options
RSoptions=( -az --delete )

# ? Preconfig finished
# ? Actual script begins

echo -e "\nThe script has begun!\n\nChecking for existing files...\n" | ${WTL[@]}

# ? Backup

##  files that could be backed up
for file in ${backupInHome[@]}; do
    (
        if [ -f "$file" ]; then
            backupFile="${BACK}${file#~}.bak"
            echo -e "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${WTL[@]}
            rsync ${RSoptions[@]} "$file" "$backupFile" #>> /dev/null
        fi
    )
done

##  .vim directory files
if [ -d ~/.vim ]; then
    echo -e "   -> Found ~/.vim directory!\n         Backing up to ${BACK}/.vim\n" | ${WTL[@]}
    rsync ${RSoptions[@]} ~/.vim ${BACK} >> /dev/null 
    # ! sudo rm -rf ~/.vim
fi

# TODO i3 needs backup aswell

##  i3 config files
if [ -d ~/.config/i3 ]; then
    echo -e "   -> Found ~/.config/i3 directory\n         Backing up to ${BACK}/i3\n" | ${WTL[@]}
    mkdir "${BACK}/i3"
    rsync ${RSoptions[@]} ~/.config/i3/ "${BACK}/i3"
fi

# ? Deployment
# 
# echo -e "Proceeding to rsync config files..." | ${WTL[@]}
# 
# for sourceFile in "${deployInHome[@]}"; do
#     (
#         echo -e "   -> Syncing $(basename -- "${sourceFile}")"
#         sudo rsync ${RSoptions[@]} "${RES}/${sourceFile}" ~ >> /dev/null
#     )
# done
# sudo rsync -a "$(pwd)/../resources/X/i3config/" ~/.config/i3 >> /dev/null
# 
# ## fonts
# if [ ! -d ~/.fonts ]; then
#     sudo mkdir ~/.fonts
# fi
# sudo rsync -a "$(pwd)/../resources/fonts/" ~/.fonts >> /dev/null
# 
# ## wallpapers
# if [ ! -d ~/pictures ]; then
#     mkdir ~/pictures
# fi
# sudo rsync ${RSoptions[@]} "$(pwd)/../resources/wallpapers" ~/pictures
# 
# # load fonts and source .Xresources file
# fc-cache
# xrdb ~/.Xresources
# 
# # ? User's choices
# 
# # vim
# echo -e ""
# read -p "Would you like to set vim as your default editor? [Y/n]" -r responseOne
# if [[ $responseOne =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $responseOne ]]; then
#     echo "export VISUAL=vim" >> ~/.bashrc
#     echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
#     echo -e "   -> Success!"
# else
#     echo -e ""
# fi
# 
# read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r responseTwo
# if [[ $responseTwo =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $responseTwo ]]; then
#     sudo rm -f /etc/default/grub
#     sudo cp ../resources/others/grub /etc/default/
# fi
# 
# echo -e "\nDeployment of configuration files has ended. Installation finished! Please open a new shell for changes to take effect." | ${WTL[@]}
# 