#!/bin/bash

# ! 1.2 HANDLES INSTALLATION OF PACKAGES

# ? Preconfig
##############################################################################################

logFile=.install_log
writeToLog=( tee -a "${logFile}" )

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "Going on by installing packages..." | ${writeToLog[@]}

${ece[@]} "\nUbuntu critical packages\n" | ${writeToLog[@]}
${apti[@]} ubuntu-drivers-common | ${writeToLog[@]}
${ece[@]} "\n" | ${writeToLog[@]}

${ece[@]} "\nVIM\n" | ${writeToLog[@]}
${apti[@]} vim | ${writeToLog[@]}
${ece[@]} "\n" | ${writeToLog[@]}

${ece[@]} "\nLightDM\n" | ${writeToLog[@]}
${apti[@]} lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings | ${writeToLog[@]}
${ece[@]} "\n" | ${writeToLog[@]}

${ece[@]} "\nLightDM\n" | ${writeToLog[@]}
${apti[@]} i3 wicd | ${writeToLog[@]}
${ece[@]} "\n" | ${writeToLog[@]}

mesa-utils mesa-utils-extra