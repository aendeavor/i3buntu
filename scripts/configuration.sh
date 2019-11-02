#!/bin/bash

# ! IN TESTING !

sudo echo -e "\nThe configuration script has begun!"

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RES="$( readlink -m "${DIR}/../resources" )"
SYS="$( readlink -m "${RES}/sys")"
BACK="$( readlink -m "${DIR}/../backups/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
LOG="${BACK}/install_log"

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

DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo Xi3/.Xresources )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "   -> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    ${RS[@]} "${SYS}/${sourceFile}" ~ >> $LOG
done

mkdir -p ~/.config/i3
${RS[@]} "${SYS}/Xi3/config" ~/.config/i3 >> $LOG
${RS[@]} "${SYS}/Xi3/i3statusconfig" ~/.config/i3 >> $LOG

sudo ${RS[@]} "${SYS}/Xi3/xorg.conf" /etc/X11 >> $LOG # brightness control

sudo mkdir -p /etc/lightdm
sudo ${RS[@]} "${SYS}/other_cfg/lightdm-gtk-greeter.conf" /etc/lightdm >> $LOG

mkdir -p ~/.urxvt/extensions
${RS[@]} "${SYS}/sh/resize-font" ~/.urxvt/ext >> $LOG

mkdir -p ~/pictures
${RS[@]} "${RES}/images" ~/pictures >> $LOG

AGTKCT='adapta-gtk-theme-colorpack'
if ! dpkg -s $AGTKCT >/dev/null 2>&1; then
    sudo dpkg -i "${RES}/design/AdaptaGTK_colorpack.deb"
fi

# reload of services and caches
xrdb ~/.Xresources >> $LOG

# ? Actual script finished
# ? Extra script begins

echo ""
read -p "Would you like me to edit nemo accordingly to your system? [Y/n]" -r R1
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    gsettings set org.cinnamon.desktop.default-applications.terminal exec 'urxvt'
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e

    gsettings set org.gnome.desktop.background show-desktop-icons false
    gsettings set org.nemo.desktop show-desktop-icons true
    sudo cp -f ${RES}/sys/other_cfg/vscode-current-dir.nemo_action "~/.local/share/nemo/actions/"
fi

read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r R2
if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    sudo rm -f /etc/default/grub
    sudo cp ${RES}/others/grub /etc/default/
    sudo update-grub 2>&1 >> $LOG
fi

# TODO use scripts, not rsync for folders
read -p "Would you like me to sync fonts?" - R3
if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    if [[ ! -d ~/.fonts ]]; then
        mkdir -p ~/.fonts
    fi
    rsync -a "${RES}/fonts/" ~/.fonts >> $LOG
    fc-cache -v -f >> $LOG
fi

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\nDeployment of configuration files has ended. Installation finished!" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like me to restart?" -r R10
if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    sudo shutdown -r now
fi
