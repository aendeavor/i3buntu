#!/bin/bash

# ! HANDLES FILES INSERTIONS AND COPYING

# ! DIRECTORIES HAVE CHANGED !

sudo echo -e "\nThe configuration script has begun!"

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RES="$( readlink -m "${DIR}/../resources" )"
BACK="$( readlink -m "${DIR}/../backups/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
LOG="${BACK}/.install_log"

RS=( rsync -avhz --delete )

##  init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

##  init of log
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG" ]]; then
        sudo rm $LOG
    fi
    touch "$LOG"
fi
WTL=( tee -a "$LOG" )

# ? Preconfig finished
# ? Actual script begins

# backup
echo -e "Checking for existing files...\n" | ${WTL[@]}

HOME_FILES=( ~/.bash_aliases ~/.bashrc ~/.vimrc ~/.Xresources )
for file in ${HOME_FILES[@]}; do
    if [[ -f "$file" ]]; then
        backupFile="${BACK}${file#~}.bak"
        echo -e "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${WTL[@]}
        ${RS[@]} "$file" "$backupFile" >> $LOG
    fi
done

if [[ -d ~/.vim ]]; then
    echo -e "   -> Found ~/.vim directory!\n         Backing up to ${BACK}/.vim\n" | ${WTL[@]}
    ${RS[@]} ~/.vim ${BACK} >> $LOG
    rm -rf ~/.vim
fi

if [ -d ~/.config/i3 ]; then
    echo -e "   -> Found ~/.config/i3 directory!\n         Backing up to ${BACK}/i3\n" | ${WTL[@]}
    ${RS[@]} ~/.config/i3 ${BACK} >> $LOG
    rm -rf ~/.config/i3
fi

# deployment
echo -e "Proceeding to deploying config files..." | ${WTL[@]}

DEPLOY_IN_HOME=( bash/.bashrc bash/.bash_aliases vim/.vimrc vim/.viminfo X/.Xresources )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "   -> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    ${RS[@]} "${RES}/${sourceFile}" ~ >> $LOG
done

mkdir -p ~/.config/i3
${RS[@]} "${RES}/X/i3config/" ~/.config/i3 >> $LOG

sudo ${RS[@]} "${RES}/X/xorg.conf" /etc/X11 >> $LOG # brightness control

sudo mkdir -p /etc/lightdm
sudo ${RS[@]} "${RES}/others/lightdm-gtk-greeter.conf" /etc/lightdm >> $LOG

mkdir -p ~/.urxvt/extensions
${RS[@]} "${RES}/X/URXVT/" ~/.urxvt/ext >> $LOG

#! ###################### UNDER CONSTRUCTION ###################### START ######################

# ##  fonts
fonts=( 'fonts/Iosevka Nerd' 'fonts/Open Sans' 'fonts/Roboto' 'fonts/Roboto Mono Nerd' 'fonts/FontAwesome' )
# if [ ! -d ~/.fonts ]; then
#     mkdir -p ~/.fonts
#     rsync -a "${RES}/fonts/" ~/.fonts >> $LOG
# fi

(cd ${DIR}/resources/icon_theme; ./install.sh -a) # ! not tested yet

#! ###################### UNDER CONSTRUCTION ###################### END   ######################

mkdir -p ~/pictures
${RS[@]} "${RES}/pictures" ~/pictures >> $LOG

pkgs='adapta-gtk-theme-colorpack'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
    sudo dpkg -i "${RES}/others/AdaptaGTKcolorpack3-94-0-149.deb"
fi

# reload of fonts, services and caches
fc-cache -v -f >> $LOG
xrdb ~/.Xresources >> $LOG

# ? Actual script finished
# ? Extra script begins

echo ""
read -p "Would you like me to edit nemo accordingly to your system? [Y/n]" -r R1
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    gsettings set org.cinnamon.desktop.default-applications.terminal exec 'urxvt'
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e
fi

read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r R2
if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    sudo rm -f /etc/default/grub
    sudo cp ${RES}/others/grub /etc/default/
    sudo update-grub 2>&1 >> $LOG
fi

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\nDeployment of configuration files has ended. Installation finished!" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like me to restart?" -r R1
if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    sudo shutdown -r now
fi
