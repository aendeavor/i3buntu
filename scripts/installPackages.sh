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
${apti[@]} ubuntu-drivers-common htop intel-microcode wicd
${ece[@]} "\n"

${ece[@]} "\nUbuntu miscellaneous packages\n"
${apti[@]} file-roller p7zip-full nomacs gparted fontconfig filezilla xsel lxappearance evince
${ece[@]} "\n" 

${ece[@]} "\nURXVT\n"
${apti[@]} rxvt-unicode neofetch
${ece[@]} "\n"

${ece[@]} "\nVIM\n"
${apti[@]} vim
${ece[@]} "\n"

${ece[@]} "\nXorg\n"
${apti[@]} xorg xserver-xorg
${ece[@]} "\n"

${ece[@]} "\nLightDM\n"
${apti[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
${ece[@]} "\n"

${ece[@]} "\nMesa\n"
${apti[@]} mesa-utils mesa-utils-extra
${ece[@]} "\n"

${ece[@]} "\ni3\n"
${apti[@]} i3-gaps compton
${ece[@]} "\n"

${ece[@]} "\nFirefox\n"
${apti[@]} --no-install-recommends firefox
${ece[@]} "\n"

${ece[@]} "\Thunderbird\n"
${apti[@]} thunderbird
${ece[@]} "\n"

${ece[@]} "\nSnap\n"
${apti[@]} snapd
${ece[@]} "\n"

${ece[@]} "Finished installing packages..."