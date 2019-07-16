#!/bin/bash

# ! HANDLES INSTALLATION OF PACKAGES

# ? Preconfig

IF=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]})

# ? Preconfig finished
# ? Actual script begins

echo -e "Start by installing packages..."

echo -e "\nUbuntu critical packages\n"
${AI[@]} ubuntu-drivers-common htop intel-microcode software-properties-common net-tools

echo -e "\nPulse audio\n"
${AI[@]} pulseaudio gstreamer1.0-pulseaudio pulseaudio-module-raop pulseaudio-module-bluetooth

echo -e "\nUbuntu miscellaneous packages\n"
${AI[@]} file-roller p7zip-full gparted fontconfig filezilla xsel lxappearance evince gedit nomacs nautilus

echo -e "\nAuthentication\n"
${AI[@]} policykit-desktop-privileges policykit-1-gnome

echo -e "\nURXVT\n"
${AI[@]} rxvt-unicode neofetch

echo -e "\nVIM\n"
${AI[@]} vim

echo -e "\nXorg\n"
${AI[@]} xorg xserver-xorg

echo -e "\nLightDM\n"
${AI[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

echo -e "\nMesa\n"
${AI[@]} mesa-utils mesa-utils-extra

echo -e "\ni3\n"
${AI[@]} i3 compton xbacklight feh rofi i3blocks

echo -e "\ni3lock-fancy\n"
${AI[@]} i3lock-fancy scrot

echo -e "\nFirefox\n"
${AI[@]} --no-install-recommends firefox

echo -e "\nThunderbird\n"
${AI[@]} thunderbird

echo -e "\nSnap\n"
${AI[@]} snapd

echo -e "\nTheming\n"
${AI[@]} gtk2-engines-pixbuf gtk2-engines-murrine

echo -e "Finished installing packages! Proceeding to removing dmenu..."

echo -e "\nDmenu\n"
sudo apt-get remove ${IF[@]} suckless-tools

echo -e "Finished reoving packages! Proceeding to updating and upgrading via APT..."

sudo apt-get update
sudo apt-get upgrade ${IF[@]}
