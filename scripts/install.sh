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
${ece[@]} "Started at: $(date)" | ${writeToLog[@]}

# ? Init of log

if [ ! -f "${logFile}" ]; then
    touch "${logFile}"
fi

# ? Start of actual installation
./installPackages.sh | ${writeToLog[@]}
./removePackages.sh | ${writeToLog[@]}
