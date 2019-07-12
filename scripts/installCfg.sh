#!/bin/bash

# ! HANDLES INSERTION OF RESORUCE FILES

# ? Preconfig

logFile=.install_log
writeToLog=( tee -a "${logFile}" )

backupDir=../backups/$(date '+%d-%m-%Y--%H:%M')

ece=( sudo echo -e )

installFlags=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
apti=( sudo apt-get install ${installFlags[@]} )

optionsRS=( -avhz --delete )


# ? Files

bashFiles=( ~/.bash_aliases ~/.bashrc )
vimFiles=( ~/.vimrc )
XFiles=( .Xresources )
i3Files=( "" )


# ? Init of log

if [ ! -f "${logFile}" ]; then
    touch "${logFile}"
fi

if [ ! -d "../backups/" ]; then
    mkdir ../backups/
fi

if [ ! -d "${backupDir}" ]; then
    mkdir "${backupDir}"
fi


${ece[@]} "\nDeployment of configuration files has begun! \nChecking for existing files...\n" | ${writeToLog[@]}

# ? Backup

# bash files
for file in ${bashFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done

# vim files
if [ -d ~/.vim ]
then
    ${ece[@]} "   -> Found ~/.vim directory!\n         Backing up to ../backups/.vim" | ${writeToLog[@]}
    sudo rsync ${optionsRS[@]} ~/.vim ${backupDir} >> /dev/null 
    # ! sudo rm -rf ~/.vim
fi
for file in ${vimFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done

# Xresources
for file in ${XFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done

# ? Deployment

#
## ? rsync for copying all needed files
#echo -e "\nProceeding to rsync bash files..." | ${writeToLog[@]}
#for sourceFile in "${bashFiles[@]}"; do
#    (
#        sudo rsync ${optionsRS[@]} ${cwd}/bash/${sourceFile} ~ >> ${logFile}
#    )
#done
#echo -e "Rsyncing bash files finished!" | ${writeToLog[@]}
#
## ? VI
#echo -e "\nProceeding to VIM..." | ${writeToLog[@]}
#read -p "Would you like to download vim? [Y/n]" -r responseOne
#if [[ $responseOne =~ ^(yes|y|Y| ) ]] || [[ -z $responseOne ]];
#then
#    sudo apt-get ${optionVI[@]} install vim > /dev/null
#    
#    if [ ! -d ~/.vim ];
#    then
#        sudo mkdir ~/.vim
#    fi
#    
#    sudo rsync ${optionsRS[@]} ${cwd}vim/ ~/.vim/ >> ${logFile}
#    sudo rsync ${optionsRS[@]} ${cwd}vim/.vimrc ~ >> ${logFile}
#
#    read -p "Would you like to download vim and set it as your default editor? [Y/n]" -r responseTwo
#    responseTwo=${responseTwo,,} # tolower
#    if [[ $responseTwo =~ ^(yes|y|Y| ) ]] || [[ -z $responseTwo ]];
#    then
#        echo "export VISUAL=vim" >> ~/.bashrc
#        echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
#    fi
#fi
#echo -e "\nVIM finished!\n" | ${writeToLog[@]}
#
#echo -e "Ended at: $(date)" >> ${logFile}
#echo -e "Installation finished!" | ${writeToLog[@]}
#echo -e "Please open a new shell for changes to take effect!"
#
#
#${ece[@]} "\nEditing GRUB has begun!" | ${writeToLog[@]}
#sudo rm -f /etc/default/grub
#sudo cp grub /etc/default/