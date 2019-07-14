#!/bin/bash

# ! 1.2 HANDLES INSTALLATION OF PACKAGES

# ? Preconfig
##############################################################################################

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "Start by installing packages..."

${ece[@]} "\nUbuntu critical packages\n"
${apti[@]} ubuntu-drivers-common htop intel-microcode

${ece[@]} "\nUbuntu miscellaneous packages\n"
${apti[@]} file-roller p7zip-full nomacs gparted fontconfig filezilla xsel lxappearance evince gedit

${ece[@]} "\nURXVT\n"
${apti[@]} rxvt-unicode neofetch

${ece[@]} "\nVIM\n"
${apti[@]} vim

${ece[@]} "\nXorg\n"
${apti[@]} xorg xserver-xorg

${apti[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

${ece[@]} "\nMesa\n"
${apti[@]} mesa-utils mesa-utils-extra

${ece[@]} "\ni3\n"
${apti[@]} i3-gaps compton pactl xbacklight feh
${ece[@]} "\n"

${ece[@]} "\nFirefox\n"
${apti[@]} --no-install-recommends firefox
${ece[@]} "\n"

${ece[@]} "\nThunderbird\n"
${apti[@]} thunderbird

${ece[@]} "\nSnap\n"
${apti[@]} snapd

${ece[@]} "Finished installing packages..."