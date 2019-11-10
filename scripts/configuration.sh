#!/bin/bash

# This script serves as the main post-packaging
# script, i.e. it backups existing config files
# and deploys new and correct version from this
# repository.
# Furthermore, reloading of services and some
# user-choices are handled, including the
# installation of chosen fonts.
# 
# current version - 0.3.6

sudo echo -e "\nThe configuration script has begun!"

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../backups/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../resources" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/install_log"

RS=( rsync -ahz --delete )

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
# ? User-choices begin

echo ""
read -p "Would you like me to edit nemo accordingly to your system? [Y/n]" -r R1
read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r R2
read -p "Would you like me to sync fonts?" - R3

# ? User-choices end
# ? Actual script begins

# backup
echo -e "Checking for existing files...\n" | ${WTL[@]}

HOME_FILES=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" "${HOME}/.Xresources" "${HOME}/.config/Code/User/settings.json" )
for file in ${HOME_FILES[@]}; do
    if [[ -f "$file" ]]; then
        backupFile="${BACK}${file#~}.bak"
        echo -e "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${WTL[@]}
        ${RS[@]} "$file" "$backupFile" >> $LOG
    fi
done

if [[ -d "${HOME}/.vim" ]]; then
    echo -e "   -> Found ~/.vim directory!\n         Backing up to ${BACK}/.vim\n" | ${WTL[@]}
    ${RS[@]} "${HOME}/.vim" "${BACK}" >> $LOG
    rm -rf "${HOME}/.vim"
fi

if [ -d "${HOME}/.config/i3" ]; then
    echo -e "   -> Found ~/.config/i3 directory!\n         Backing up to ${BACK}/i3\n" | ${WTL[@]}
    ${RS[@]} "${HOME}/.config/i3" ${BACK} >> $LOG
    rm -rf "${HOME}/.config/i3"
fi

# deployment
echo -e "Proceeding to deploying config files..." | ${WTL[@]}

DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo Xi3/.Xresources )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "   -> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    ${RS[@]} "${SYS}/${sourceFile}" "${HOME}" >> $LOG
done

mkdir -p "${HOME}/.config/i3"
${RS[@]} "${SYS}/Xi3/config" "${HOME}/.config/i3" >> $LOG
${RS[@]} "${SYS}/Xi3/i3statusconfig" "${HOME}/.config/i3" >> $LOG

sudo ${RS[@]} "${SYS}/Xi3/xorg.conf" /etc/X11 >> $LOG

sudo mkdir -p /etc/lightdm
sudo ${RS[@]} "${SYS}/other_cfg/lightdm-gtk-greeter.conf" /etc/lightdm >> $LOG

mkdir -p "${HOME}/.urxvt/extensions"
${RS[@]} "${SYS}/sh/resize-font" "${HOME}/.urxvt/ext" >> $LOG

mkdir -p "${HOME}/pictures"
${RS[@]} "${RES}/images" "${HOME}/pictures" >> $LOG

AGTKCT='adapta-gtk-theme-colorpack'
if ! dpkg -s ${AGTKCT} >/dev/null 2>&1; then
    sudo dpkg -i "${RES}/design/AdaptaGTK_colorpack.deb"
fi

CC="${HOME}/.config/Code/User"
mkdir -p "${CC}"
${RS[@]} "${SYS}/vscode/settings.json" "${CC}" >> $LOG

# reload of services and caches
xrdb ${HOME}/.Xresources >> $LOG

# ? Actual script finished
# ? Extra script begins

if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    gsettings set org.cinnamon.desktop.default-applications.terminal exec 'urxvt'
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e

    gsettings set org.gnome.desktop.background show-desktop-icons false
    gsettings set org.nemo.desktop show-desktop-icons true
    sudo cp -f "${RES}/sys/other_cfg/vscode-current-dir.nemo_action" "${HOME}/.local/share/nemo/actions/"
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    sudo rm -f /etc/default/grub
    sudo cp ${RES}/others/grub /etc/default/
    sudo update-grub 2>&1 >> $LOG
fi

# deployment of fonts
if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    find "${DIR}/resources/fonts/" -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;

    ( cd "${DIR}/resources/fonts/" && ./fonts.sh "${LOG}" )

    echo -e "Renewing font-cache..."
    fc-cache -f >> $LOG && echo -e "Finished renewing font-cache!"
fi

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\nDeployment of configuration files has ended. Installation finished!" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like me to restart?" -r R10
if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    sudo shutdown -r now
fi
