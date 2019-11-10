#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages. Via APT, core utils,
# browser, graphical environment and much more is
# being installed.
#
# current version - 0.3.4

sudo echo -e "\nInstallation has begun!"

# ? Preconfig

##  directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../backups/packageInstallation/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/.install_log"

IF=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

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

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

EXEC="${DIR}/../resources/scripts/packaging.sh"
if [[ ! -x "$EXEC" ]]; then
    sudo chmod +x $EXEC
fi

# ? Preconfig finished
# ? User-choices begin

echo -e "Please make your choices: \n"

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
    read -p "Would you like to install recommended VS Code extensions?" -r RC1
fi

read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r R10

# ? User-choices end
# ? Actual script begins

echo -e "Started at: $(date)"
echo -e 'Installing packages...'

echo -e "\nUbuntu critical packages\n"
${AI[@]} ubuntu-drivers-common htop intel-microcode software-properties-common curl

echo -e "\nNetworking\n"
${AI[@]} --install-recommends net-tools network-manager*

echo -e "\nPulse audio\n"
${AI[@]} pulseaudio gstreamer1.0-pulseaudio pulseaudio-module-raop pulseaudio-module-bluetooth

echo -e "\nUbuntu miscellaneous packages\n"
${AI[@]} file-roller p7zip-full gparted fontconfig filezilla
${AI[@]} xsel lxappearance evince gedit nomacs nemo python3-distutils

echo -e "\nAuthentication\n"
${AI[@]} policykit-desktop-privileges policykit-1-gnome

echo -e "\nURXVT\n"
${AI[@]} rxvt-unicode neofetch

echo -e "\nVIM\n"
${AI[@]} vim

echo -e "\nXorg\n"
${AI[@]} xorg xserver-xorg

echo -e "\nLightDM\n"
${AI[@]} lightdm lightdm-gtk-greeter
##  lightdm-gtk-greeter-settings

echo -e "\nMesa\n"
${AI[@]} mesa-utils mesa-utils-extra

echo -e "\ni3\n"
${AI[@]} i3 compton xbacklight feh rofi arandr

echo -e "\ni3lock-fancy\n"
${AI[@]} i3lock-fancy scrot

echo -e "\nFirefox\n"
${AI[@]} --no-install-recommends firefox

echo -e "\nThunderbird\n"
${AI[@]} thunderbird

echo -e "\nSnap\n"
${AI[@]} snapd

echo -e "\nGNOME Keyring\n"
${AI[@]} gnome-keyring* libgnome-keyring0

echo -e "\nTheming\n"
${AI[@]} gtk2-engines-pixbuf gtk2-engines-murrine

echo -e "\nFonts - Roboto & OpenSans\n"
${AI[@]} fonts-roboto fonts-open-sans

echo - "\nIcon Theme\n"
(
    cd "${DIR}/../resources/icon_theme/icon_theme.sh"
    find . -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
    ./icon_theme.sh
)

echo -e 'Finished installing packages! Proceeding to removing dmenu...'

echo -e "\nDmenu\n"
sudo apt-get remove ${IF[@]} suckless-tools

echo -e 'Finished reoving packages! Proceeding to updating and upgrading via APT...'

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

echo -e 'Finished with the actual script.'

# ? Actual script finished
# ? Extra script begins

echo -e 'Processing user-choices...'

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo -e 'Enabling ubuntu-drivers autoinstall...'
    sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    if [[ $(lsb_release -r) == *"18.04"* ]]; then
        echo -e 'Installing OpenJDK 11...'
        ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
    else
        echo -e 'Installing OpenJDK 12...'
        ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
    fi
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e 'Installing Cryptomator...'
    sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
    ${AI[@]} cryptomator
fi

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    ${AI[@]} balena-etcher-electron
fi

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    echo -e 'Installing LaTeX...'
    ${AI[@]} texlive-full
fi

if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
    echo -e 'Installing OwnCloud...'
    ${AI[@]} owncloud-client
fi

if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
    echo -e 'Installing build-essential & cmake...'
    ${AI[@]} build-essential cmake
fi

if [[ $R8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R8 ]]; then
    echo -e 'Installing RUST...'
    curl https://sh.rustup.rs -sSf | sh -s -- --profile complete
    if [[ -e "~/.cargo/bin/rustup"]]; then
        mkdir -p "~/.local/share/bash-completion/completions"
        rustup completions bash &>> "~/.local/share/bash-completion/completions/rustup"

        rustup set profile complete

        COMPONENTS=( rust-docs rust-src rustfmt rls clippy )

        for COMPONENT in ${COMPONENTS[@]}; do
            rustup component add $COMPONENT &>> "$LOG"
        done

        rustup update
    fi
fi

if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    echo -e 'Installing VS Code...'
    ${SI[@]} code --classic
fi

if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    echo -e "Installing JetBrains' IDE suite..."
    ${SI[@]} intellij-idea-ultimate --classic
    ${SI[@]} kotlin --classic
    ${SI[@]} kotlin-native --classic
    ${SI[@]} pycharm-professional --classic
    ${SI[@]} clion --classic
fi

if [[ $RC1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC1 ]]; then
    echo -e 'Installing VS Code Extensions...'
    sudo chmod +x "${DIR}/resources/sys/vscode/extensions.sh"
    "${DIR}/resources/sys/vscode/extensions.sh"
fi

echo -e 'Finished with processing user-choices! One last update...'

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade
sudo snap refresh

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "The script has finished!\nEnded at: $(date)"

for I in {5..1..-1}; do
    echo -ne "\rRestart in $I seconds"
    sleep 1
done
sudo shutdown -r now
