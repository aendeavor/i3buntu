#!/bin/bash

# ! HANDLES INSTALLATION OF PACKAGES

# ? Preconfig

IF=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

# ? Preconfig finished
# ? Actual script begins

echo -e "Installing packages..."

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

echo -e "Finished installing packages! Proceeding to removing dmenu..."

echo -e "\nDmenu\n"
sudo apt-get remove ${IF[@]} suckless-tools

echo -e "Finished reoving packages! Proceeding to updating and upgrading via APT..."

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

# ? Actual script finished
# ? Extra script begins

echo -e "Finished with the actual script."

## graphics driver
read -p "Would you like me to execute ubuntu-driver autoinstall? [Y/n]" -r R1
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    sudo ubuntu-drivers autoinstall
fi

## Java
read -p "Would you like me to install OpenJDK? [Y/n]" -r R2
if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    if [[ $(lsb_release -r) == *"18.04"* ]]; then
        ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
    else
        ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
    fi
fi

read -p "Would you like me to install Cryptomator? [Y/n]" -r R3
if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    sudo add-apt-repository ppa:sebastian-stenzel/cryptomator
    ${AI[@]} cryptomator
fi

read -p "Would you like me to install Balena Etcher? [Y/n]" -r R4
if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    ${AI[@]} balena-etcher-electron
fi

read -p "Would you like me to install TeX? [Y/n]" -r R5
if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    ${AI[@]} texlive-full
fi

read -p "Would you like me to install ownCloud? [Y/n]" -r R6
if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
    ${AI[@]} owncloud-client
fi

read -p "Would you like me to install Build-Essentials? [Y/n]" -r R7
if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
    ${AI[@]} build-essential cmake
fi

read -p "Would you like me to get RUST? [Y/n]" -r R8
if [[ $R8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R8 ]]; then
    curl https://sh.rustup.rs -sSf | sh
fi

read -p "Would you like me to install VS Code? [Y/n]" -r R9
if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    ${SI[@]} code --classic
fi

read -p "Would you like me to install the JetBrains IDE suit? [Y/n]" -r R10
if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    ${SI[@]} intellij-idea-ultimate --classic
    ${SI[@]} kotlin --classic
    ${SI[@]} kotlin-native --classic
    ${SI[@]} pycharm-professional --classic
    ${SI[@]} clion --classic
fi

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

# ? Extra script finished - returning
