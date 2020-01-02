#!/bin/bash

# This script serves as the main post-packaging
# script, i.e. it backups existing config files
# and deploys new and correct version from this
# repository.
# Furthermore, reloading of services and some
# user-choices are handled, including the
# installation of chosen fonts.
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
# ? User-choices begin

sudo echo -e "${INF}Configuration has begun!\n${INF}Please make your choices:\n"

read -p "Would you like to edit nemo accordingly to your system? [Y/n]" -r R1
read -p "Would you like to edit /etc/default/grub? [Y/n]" -r R2
read -p "Would you like to sync fonts? [Y/n]" -r R3

# ? User-choices end
# ? Actual script begins

echo -e "\n${INF}Started at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Checkig for existing files\n" | ${WTL[@]}

## backup of configuration files
HOME_FILES=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" "${HOME}/.Xresources" )
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
echo -e "\n${INF}Deploying config files" | ${WTL[@]}

DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo Xi3/.Xresources )
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
done

mkdir -p "${HOME}/.config/i3" "${HOME}/.urxvt/extensions" "${HOME}/.config" "${HOME}/images"
sudo mkdir -p /usr/share/lightdm /etc/lightdm

echo -e "-> Syncing i3's config"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/config" "${HOME}/.config/i3"

echo -e "-> Syncing i3's statusconfig"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/i3statusconfig" "${HOME}/.config/i3"

echo -e "-> Syncing xorg.conf"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/Xi3/xorg.conf" /etc/X11

echo -e "-> Syncing lightdm-gtk-greeter.conf"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/other_cfg/lightdm-gtk-greeter.conf" /etc/lightdm

echo -e "-> Syncing lightdm wallpaper"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${RES}/images/firewatch.jpg" /usr/share/lightdm

echo -e "-> Syncing URXVT resize-font extension"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/resize-font" "${HOME}/.urxvt/ext"

echo -e "-> Syncing compton.conf"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/other_cfg/compton.conf" "${HOME}/.config"

if ! dpkg -s neovim >/dev/null 2>&1; then
    echo -e "-> Syncing NeoVim's config"  | ${WTL[@]}
    mkdir -p ~/.config/nvim/colors
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/init.vim" "${HOME}/.config/nvim"
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/colors/" "${HOME}/.config/nvim"
fi


echo -e "-> Syncing images directory"  | ${WTL[@]}
>/dev/null 2>>"${LOG}" ${RS[@]} "${RES}/images" "${HOME}" 

if [[ -d "${HOME}/.config/Code" ]]; then
    echo -e "-> Syncing VS Code settings"  | ${WTL[@]}
    sudo mkdir -p "${HOME}/.config/Code/User"
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vscode/settings.json" "${HOME}/.config/Code/User"
fi

echo -e "\n${INF} Reloading X-services"
>/dev/null 2>>"${LOG}" xrdb ${HOME}/.Xresources 

echo -e "${SUC}Finished with the actual script" | ${WTL[@]}

# ? Actual script finished
# ? Extra script begins

echo -e "${INF}Processing user-choices" | ${WTL[@]}

if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    printf "\n-> Nemo is being configured..."
    
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    gsettings set org.cinnamon.desktop.default-applications.terminal exec 'urxvt'
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e

    gsettings set org.gnome.desktop.background show-desktop-icons false
    gsettings set org.nemo.desktop show-desktop-icons true
    mkdir -p "${HOME}/.local/share/nemo/actions"
    sudo cp -f "${RES}/sys/other_cfg/vscode-current-dir.nemo_action" "${HOME}/.local/share/nemo/actions/"

    printf "\t finished."
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    printf "\n-> Grub is being configured..."

    &>/dev/null sudo cp /etc/default/grub "${BACK}"
    &>/dev/null sudo rm -f /etc/default/grub
    &>/dev/null sudo cp ${RES}/sys/other_cfg/grub /etc/default/
    >/dev/null 2>>"${LOG}" sudo update-grub

    printf "\t finished."
fi

## deployment of fonts
if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e "\n${INF} Fonts are processed\n" | ${WTL[@]}
    
    find "${RES}/fonts/" -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
    (
        cd "${RES}/fonts/"
        ./fonts.sh | ${WTL[@]}
    )

    echo -e "\n${INF}Renewing font cache" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" fc-cache -f
fi

echo -e "\n${SUC}Finished with processing user-choices" | ${WTL[@]}

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\n${INF}The script has finished!\n${INF}Ended at: $(date '+%d.%m.%Y-%H:%M')\n" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like to restart? [Y/n]" -r RESTART
if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
    shutdown -r now
fi
