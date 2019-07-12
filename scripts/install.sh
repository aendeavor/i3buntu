#!/bin/bash

# ! 1 HANDLES INITIAL INSTALLATION

# ? Preconfig
##############################################################################################

logFile=.install_log
writeToLog=( tee -a "${logFile}" )

backupFile=../backups/$(date)
writeToBackup=(cp -rf "${backupFile}")

ece=( sudo echo -e )

installFlags=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
apti=( sudo apt-get install ${installFlags[@]})

##############################################################################################

${ece[@]} "\nInstallation has begun!" | ${writeToLog[@]}

# ? Init of log and backup directory

if [ ! -f "${logFile}" ]; then
    touch "${logFile}"
fi

if [ ! -d "../backups/" ]; then
    mkdir ../backups/
fi

if [ ! -d "${backupFile}" ]; then
    mkdir "${backupFile}"
fi

# ? Start of actual installation
./removePackages.sh | ${writeToLog[@]}
./installPackages.sh | ${writeToLog[@]}

${ece[@]} "\nEditing GRUB has begun!" | ${writeToLog[@]}
sudo rm -f /etc/default/grub
sudo cp grub /etc/default/
