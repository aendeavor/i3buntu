#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# version   0.9.0
# sources   <https://afshinm.name/neovim/>

sudo echo -e "\nPackaging stage has begun!"

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}"
WAR="${YEL}WARNING${NC}"
SUC="${GRE}SUCCESS${NC}"

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
WTL=( tee -a "${LOG}" )

# ? Preconfig finished
# ? User-choices begin

echo -e "\nPlease make your choices:"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install OpenJDK? [Y/n]" -r R2
read -p "Would you like to install Cryptomator? [Y/n]" -r R3
read -p "Would you like to install Balena Etcher? [Y/n]" -r R4
read -p "Would you like to install TeX? [Y/n]" -r R5
read -p "Would you like to install ownCloud? [Y/n]" -r R6
read -p "Would you like to install Build-Essentials? [Y/n]" -r R7
read -p "Would you like to get RUST? [Y/n]" -r R8
read -p "Would you like to install VS Code? [Y/n]" -r R9

RC1="no"
if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    read -p "Would you like to install recommended VS Code extensions? [Y/n]" -r RC1
fi

read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r R10
read -p "Would you like to install Docker? [Y/n]" -r R11
read -p "Would you like to install NeoVIM? [Y/n]" -r R12

# ? User choices end
# ? Init of package selection

CRITICAL=(
    ubuntu-drivers-common
    intel-microcode
    curl
    wget
    libaio1

    net-tools
    network-manager*
    
    software-properties-common
    python3-distutils
    snapd

    rxvt-unicode
    vim

    nemo
    file-roller
    p7zip-full

    rofi

    policykit-desktop-privileges
    policykit-1-gnome
    gnome-keyring*
    libgnome-keyring0

    firefox
    thunderbird
)

ENV=(
    xorg
    xserver-xorg
    xbacklight

    lightdm
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings

    i3
    i3lock
    feh
    compton
    
    mesa-utils
    mesa-utils-extra

    gtk2-engines-pixbuf
    gtk2-engines-murrine
    
    lxappearance
    arandr

    pulseaudio
    gstreamer1.0-pulseaudio
    pulseaudio-module-raop
    pulseaudio-module-bluetooth
)

MISC=(
    xsel
    xclip

    neofetch
    htop

    fonts-roboto
    fonts-open-sans
    fonts-lyx

    gparted

    fontconfig
    compton-conf
    
    evince
    gedit
    nomacs
    
    scrot
)

PACKAGES=( "${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}" )

# ? End of init of package selection
# ? Actual script begins

echo -e "\nStarted at: $(date)\n\nInitial update" | ${WTL[@]}

>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade

echo -e "Installing packages:\n" | ${WTL[@]}

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

# needs to be checked first, as LightDM conflicts with these packages
>/dev/null 2>>"${LOG}" sudo apt-get remove ${IF[@]} liblightdm-gobject* liblightdm-qt*
EC=$?
printf "%-35s | %-15s | %-15s" "liblightdm-*" "Removed" "${EC}"
printf "\n"
&>>"${LOG}" echo -e "dmenu\n\t -> EXIT CODE: ${EC}"
unset EC

for PACKAGE in "${PACKAGES[@]}"; do
    >/dev/null 2>>"${LOG}" ${AI[@]} ${PACKAGE}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
        printf "\n"
    fi

    &>>"${LOG}" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
done

>/dev/null 2>>"${LOG}" sudo apt-get remove ${IF[@]} suckless-tools
EC=$?
printf "%-35s | %-15s | %-15s" "dmenu" "Removed" "${EC}"
printf "\n"
&>>"${LOG}" echo -e "dmenu\n\t -> EXIT CODE: ${EC}"
unset EC

echo -e "\nIcon-Theme is being processed..." | ${WTL[@]}
(
    cd "${DIR}/../resources/icon_theme"
    &>>"${LOG}" find . -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
    &>>"${LOG}" ./icon_theme.sh "$LOG"
)

if ! dpkg -s adapta-gtk-theme-colorpack >/dev/null 2>&1; then
    echo -e "Color-Pack is being processed...\n" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo dpkg -i "${DIR}/../resources/design/AdaptaGTK_colorpack.deb"
fi

echo -e 'Post-Update via APT' | ${WTL[@]}
>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade

echo -e '\nFinished with the actual script.' | ${WTL[@]}

# ? Actual script finished
# ? Extra script begins

echo -e 'Processing user-choices:\n' | ${WTL[@]}

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo -e 'Enabling ubuntu-drivers autoinstall...' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    if [[ $(lsb_release -r) == *"18.04"* ]]; then
        echo -e 'Installing OpenJDK 11...' | ${WTL[@]}
        >/dev/null 2>>"${LOG}" ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
    else
        echo -e 'Installing OpenJDK 12...' | ${WTL[@]}
        >/dev/null 2>>"${LOG}" ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
    fi
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e 'Installing Cryptomator...' | ${WTL[@]}
    &>>"${LOG}" sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
    >/dev/null 2>>"${LOG}" ${AI[@]} cryptomator
fi

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    echo -e 'Installing Etcher...' | ${WTL[@]}
    if [[ ! -e /etc/apt/sources.list.d/balena-etcher.list ]]; then
        sudo touch /etc/apt/sources.list.d/balena-etcher.list
    fi

    echo "deb https://deb.etcher.io stable etcher" | >/dev/null sudo tee /etc/apt/sources.list.d/balena-etcher.list
    &>>"${LOG}" sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    >/dev/null 2>>"${LOG}" ${AI[@]} balena-etcher-electron
fi

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    echo -e 'Installing LaTeX...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} texlive-full
fi

if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
    echo -e 'Installing OwnCloud...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} owncloud-client
fi

if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
    echo -e 'Installing build-essential & cmake...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
fi

if [[ $R8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R8 ]]; then
    echo -e '\n\nInstalling RUST...' | ${WTL[@]}
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete
    source "${HOME}/.cargo/env"
    
    mkdir -p "${HOME}/.local/share/bash-completion/completions"
    touch "${HOME}/.local/share/bash-completion/completions/rustup"
    rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

    COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
    for COMPONENT in ${COMPONENTS[@]}; do
        &>>"${LOG}" rustup component add $COMPONENT
    done

    if [[ ! -z $(which code) ]]; then
        code --install-extension rust-lang.rust
    fi

    &>>"${LOG}" rustup update
fi

if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    echo -e '\nInstalling VS Code...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${SI[@]} code --classic
fi

if [[ $RC1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC1 ]]; then
    echo -e 'Installing VS Code Extensions...' | ${WTL[@]}
    sudo chmod +x "${DIR}/../resources/sys/vscode/extensions.sh"
    &>>"${LOG}" "${DIR}/../resources/sys/vscode/extensions.sh"
fi

if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    echo -e "Installing JetBrains' IDE suite..." | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${SI[@]} intellij-idea-ultimate --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} kotlin --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} kotlin-native --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} pycharm-professional --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} clion --classic
fi

if [[ $RC11 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC11 ]]; then
    echo -e 'Installing Docker...' | ${WTL[@]}
    $(readlink -m "${DIR}/../sys/docker/get_docker.sh") $DIR
fi

if [[ $RC12 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC12 ]]; then
    echo -e 'Installing NeoVIM...' | ${WTL[@]}
    sudo apt install neovim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo -e "${WAR} You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell."
    echo -e "${WAR} Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer --tern-completer."
fi

echo -e 'Finished with processing user-choices. One last update...' | ${WTL[@]}

>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade
>/dev/null 2>>"${LOG}" sudo snap refresh

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\nThe script has finished!\nEnded at: $(date)\n" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like me to restart? [Y/n]" -r Rrestart
if [[ $Rrestart =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $Rrestart ]]; then
    shutdown -r now
fi
