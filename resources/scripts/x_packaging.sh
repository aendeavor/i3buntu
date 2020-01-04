#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# version   0.9.3
# sources   https://afshinm.name/neovim/

sudo printf ""

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
WTL=( tee -a "${LOG}" )

# ? Preconfig finished
# ? User-choices begin

echo -e "${INF}Packaging has begun!\n${INF}Please make your choices:\n"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install OpenJDK? [Y/n]" -r R2
read -p "Would you like to install Cryptomator? [Y/n]" -r R3
read -p "Would you like to install Balena Etcher? [Y/n]" -r R4
read -p "Would you like to install TeX? [Y/n]" -r R5
read -p "Would you like to install ownCloud? [Y/n]" -r R6
read -p "Would you like to install Build-Essentials? [Y/n]" -r R7
read -p "Would you like to install NeoVIM? [Y/n]" -r R8
read -p "Would you like to install VS Code? [Y/n]" -r R9

RC1="no"
if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    read -p "Would you like to install recommended VS Code extensions? [Y/n]" -r RC1
fi

read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r R10
read -p "Would you like to install Docker? [Y/n]" -r R11

if [[ $R11 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R11 ]]; then
    echo -e "\n${WAR}Docker has been chosen as an installation candidate. This may reqire manual user-input near the end of this script.\n"
fi

read -p "Would you like to install RUST? [Y/n]" -r R12

if [[ $R12 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R12 ]]; then
    echo -e "\n${WAR}Rust has been chosen as an installation candidate. This reqires manual user-input at the end of this script.\n"
    sleep 3s
fi
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

    ruby

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

echo -e "${INF}Started at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Initial update" | ${WTL[@]}

>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade

echo -e "${INF}Installing packages\n" | ${WTL[@]}

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

## needs to be checked first, as LightDM conflicts with these packages
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
    fi
    
    printf "\n"
    &>>"${LOG}" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
done

>/dev/null 2>>"${LOG}" sudo apt-get remove ${IF[@]} suckless-tools
EC=$?
printf "%-35s | %-15s | %-15s" "dmenu" "Removed" "${EC}"
printf "\n\n"
&>>"${LOG}" echo -e "dmenu\n\t -> EXIT CODE: ${EC}"
unset EC

echo -e "${INF}Icon-Theme is being processed" | ${WTL[@]}
(
    cd "${DIR}/../icon_theme"
    &>>"${LOG}" find . -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
    &>>"${LOG}" ./icon_theme.sh "$LOG"
)

if ! dpkg -s adapta-gtk-theme-colorpack >/dev/null 2>&1; then
    echo -e "${INF}Color-Pack is being processed" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo dpkg -i "${DIR}/../resources/design/AdaptaGTK_colorpack.deb"
fi

echo -e "${SUC}Finished with actual script" | ${WTL[@]}

# ? Actual script finished
# ? Extra script begins

echo -e "${INF}Processing user-choices\n" | ${WTL[@]}

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo 'Enabling ubuntu-drivers autoinstall' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    if [[ $(lsb_release -r) == *"18.04"* ]]; then
        echo 'Installing OpenJDK 11' | ${WTL[@]}
        >/dev/null 2>>"${LOG}" ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
    else
        echo 'Installing OpenJDK 12' | ${WTL[@]}
        >/dev/null 2>>"${LOG}" ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
    fi
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo 'Installing Cryptomator' | ${WTL[@]}
    &>>"${LOG}" sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
    &>>/dev/null sudo apt update
    >/dev/null 2>>"${LOG}" ${AI[@]} cryptomator
fi

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    echo 'Installing Etcher Electron' | ${WTL[@]}
    if [[ ! -e /etc/apt/sources.list.d/balena-etcher.list ]]; then
        sudo touch /etc/apt/sources.list.d/balena-etcher.list
    fi

    echo "deb https://deb.etcher.io stable etcher" | >/dev/null sudo tee /etc/apt/sources.list.d/balena-etcher.list
    &>>"${LOG}" sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    &>>/dev/null sudo apt update
    >/dev/null 2>>"${LOG}" ${AI[@]} balena-etcher-electron
fi

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    echo -e 'Installing LaTeX...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} texlive-full
    >/dev/null 2>>"${LOG}" ${AI[@]} python3-pygments
fi

if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
    echo 'Installing ownCloud' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} owncloud-client
fi

if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
    echo 'Installing build-essential & CMake' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
fi

if [[ $RC8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC8 ]]; then
    echo -e 'Installing NeoVIM...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo apt install neovim
    >/dev/null 2>>"${LOG}" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    echo -e "\t-->${WAR}You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell."
    echo -e "\t-->${WAR}Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer --tern-completer."
    sleep 3s
fi

if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    echo 'Installing Visual Studio Code' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${SI[@]} code --classic
fi

if [[ $RC1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC1 ]]; then
    echo 'Installing Visual Studio Code Extensions' | ${WTL[@]}
    &>>"${LOG}" "${DIR}/../resources/sys/vscode/extensions.sh"
fi

if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    echo "Installing JetBrains' IDE suite" | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${SI[@]} intellij-idea-ultimate --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} kotlin --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} kotlin-native --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} pycharm-professional --classic
    >/dev/null 2>>"${LOG}" ${SI[@]} clion --classic
fi

if [[ $RC11 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC11 ]]; then
    echo -e 'Installing Docker' | ${WTL[@]}
    echo -e "${WAR}Manual user-input may be requiered!\n" | ${WTL[@]}
    $(readlink -m "${DIR}/../sys/docker/get_docker.sh") $DIR
fi

if [[ $R12 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R12 ]]; then
    echo -e "Installing RUST" | ${WTL[@]}
    echo -e "${WAR}Manual user-input requiered!\n" | ${WTL[@]}

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
        code --install-extension rust-lang.rust >/dev/null 2>>${LOG}
    fi

    >/dev/null 2>>"${LOG}" rustup update
fi

echo -e "\n${SUC}Finished with processing user-choices" | ${WTL[@]}

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "\n${INF}The script has finished!\n${INF}Ended at: $(date '+%d.%m.%Y-%H:%M')\n" | ${WTL[@]}
read -p "It is recommended to restart now. Would you like to restart? [Y/n]" -r RESTART
if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
    shutdown -r now
fi
