#!/bin/bash

# ! 1.2 HANDLES INSTALLATION OF PACKAGES

# ? Preconfig
##############################################################################################

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "Now installing packages..."

${ece[@]} "\nUbuntu critical packages\n"
${apti[@]} ubuntu-drivers-common htop intel-microcode
${ece[@]} "\n"

rxvt-unicode

${ece[@]} "\nVIM\n"
${apti[@]} vim
${ece[@]} "\n"

${ece[@]} "\nLightDM\n"
${apti[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
${ece[@]} "\n"

${ece[@]} "\nLightDM\n"
${apti[@]} i3 wicd compton
${ece[@]} "\n"

${ece[@]} "\nMesa\n"
${apti[@]} mesa-utils mesa-utils-extra
${ece[@]} "\n"

xorg xserver-xorg

${ece[@]} "Finished installing packages..."