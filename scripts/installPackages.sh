#!/bin/bash

# ! HANDLES INSTALLATION OF PACKAGES

# ? Preconfig

IF=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
AI=( sudo apt-get install ${IF[@]})

# ? Preconfig finished
# ? Actual script begins

echo -e "Start by installing packages..."

echo -e "\nUbuntu critical packages\n"
${AI[@]} ubuntu-drivers-common htop intel-microcode

echo -e "\nUbuntu miscellaneous packages\n"
${AI[@]} file-roller p7zip-full nomacs gparted fontconfig filezilla xsel lxappearance evince gedit

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
${AI[@]} i3-gaps compton pactl xbacklight feh

echo -e "\nFirefox\n"
${AI[@]} --no-install-recommends firefox

echo -e "\nThunderbird\n"
${AI[@]} thunderbird

echo -e "\nSnap\n"
${AI[@]} snapd

echo -e "Finished installing packages! Proceeding to updating and upgrading via APT..."

sudo apt-get update
sudo apt-get upgrade ${IF}
