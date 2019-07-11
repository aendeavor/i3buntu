#!/bin/bash

# ! 1.2 HANDLES INSTALLATION OF PACKAGES

# ? Preconfig
##############################################################################################

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "Going on by installing packages..."

${ece[@]} "\nUbuntu critical packages\n"
${apti[@]} ubuntu-drivers-common
${ece[@]} "\n"

${ece[@]} "\nVIM\n"
${apti[@]} vim
${ece[@]} "\n"

${ece[@]} "\nLightDM\n"
${apti[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
${ece[@]} "\n"

${ece[@]} "\nLightDM\n"
${apti[@]} i3 wicd
${ece[@]} "\n"

${ece[@]} "\nMesa\n"
${apti[@]} mesa-utils mesa-utils-extra
${ece[@]} "\n"
