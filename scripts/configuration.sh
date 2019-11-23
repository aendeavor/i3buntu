#!/bin/bash

# This script serves as the main post-packaging
# script, i.e. it backups existing config files
# and deploys new and correct version from this
# repository.
# Furthermore, reloading of services and some
# user-choices are handled, including the
# installation of chosen fonts.
# 
# current version - 0.3.9

sudo echo -e "\nThe configuration stage has begun!"

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../backups/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../resources" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/configuration_log"

RS=( rsync -ahq --delete )

## Init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

## Init of logfile
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG" ]]; then
        &>/dev/null sudo rm $LOG
    fi
    touch "$LOG"
fi
WTL=( tee -a "$LOG" )

# ? Preconfig finished
# ? User-choices begin

echo ""
read -p "Would you like me to edit nemo accordingly to your system? [Y/n]" -r R1
read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r R2
read -p "Would you like me to sync fonts? [Y/n]" -r R3

# ? User-choices end
# ? Actual script begins

## Backup
echo -e "\nChecking for existing files..." | ${WTL[@]}

HOME_FILES=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" "${HOME}/.Xresources" "${HOME}/.config/Code/User/settings.json" "${HOME}/.config/compton.conf" )
for FILE in ${HOME_FILES[@]}; do
    if [[ -f "$file" ]]; then
        backupFile="${BACK}${FILE#~}.bak"
        echo -e "   -> Found ${FILE}!\n         Backing up to ${backupFile}\n" | ${WTL[@]}
        >/dev/null 2>>"${LOG}" sudo ${RS[@]} "$FILE" "$backupFile"
    fi
done

if [[ -d "${HOME}/.vim" ]]; then
    echo -e "   -> Found ~/.vim directory!\n         Backing up to ${BACK}/.vim\n" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.vim" "${BACK}"
    rm -rf "${HOME}/.vim"
fi

if [ -d "${HOME}/.config/i3" ]; then
    echo -e "   -> Found ~/.config/i3 directory!\n         Backing up to ${BACK}/i3\n" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.config/i3" "${BACK}"
    rm -rf "${HOME}/.config/i3"
fi

## Deployment
echo -e "Proceeding to deploying config files..." | ${WTL[@]}

DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo Xi3/.Xresources )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "   -> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
done

mkdir -p "${HOME}/.config/i3"
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/config" "${HOME}/.config/i3"
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/i3statusconfig" "${HOME}/.config/i3"

sudo ${RS[@]} "${SYS}/Xi3/xorg.conf" /etc/X11

sudo mkdir -p /etc/lightdm
sudo mkdir -p /usr/share/lightdm
>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/other_cfg/lightdm-gtk-greeter.conf" /etc/lightdm
>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${RES}/images/firewatch.jpg" /usr/share/lightdm

mkdir -p "${HOME}/.urxvt/extensions"
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/resize-font" "${HOME}/.urxvt/ext"

mkdir -p "${HOME}/.config"
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/other_cfg/compton.conf" "${HOME}/.config"

mkdir -p "${HOME}/pictures"
>/dev/null 2>>"${LOG}" ${RS[@]} "${RES}/images" "${HOME}/pictures" 

AGTKCT='adapta-gtk-theme-colorpack'
if ! dpkg -s ${AGTKCT} >/dev/null 2>&1; then
    >/dev/null 2>>"${LOG}" sudo dpkg -i "${RES}/design/AdaptaGTK_colorpack.deb"
fi

CC="${HOME}/.config/Code/User"
mkdir -p "${CC}"
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vscode/settings.json" "${CC}" 

## Reload of services and caches
>/dev/null 2>>"${LOG}" xrdb ${HOME}/.Xresources 

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
    >/dev/null 2>>"${LOG}" sudo update-grub
fi

## Deployment of fonts
if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    find "${DIR}/resources/fonts/" -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;

    ( cd "${DIR}/resources/fonts/" && ./fonts.sh "${LOG}" )

    echo -e "Renewing font-cache..."
    fc-cache -f >/dev/null 2>>"${LOG}"
    echo -e "Finished renewing font-cache!" | ${WTL[@]}
fi

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\nDeployment of configuration files has ended. Installation finished!\n\n" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like me to restart?" -r R10
if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    sudo shutdown -r now
fi
