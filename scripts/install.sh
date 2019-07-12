#!/bin/bash

# ! 1 HANDLES INITIAL INSTALLATION

# ? Preconfig
##############################################################################################

logFile=.install_log
writeToLog=( tee -a "${logFile}" )

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "\nInstallation has begun!" | ${writeToLog[@]}

if [ ! -f "${logFile}" ]
then
    touch "${logFile}"
fi

./removePackages.sh | ${writeToLog[@]}
./installPackages.sh | ${writeToLog[@]}

${ece[@]} "\nEditing GRUB has begun!" | ${writeToLog[@]}
