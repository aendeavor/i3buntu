#!/bin/bash

# ! HANDLES INSTALLATION

# ? important directories and commands
############################################################################
cwd=$(pwd)/
backupDir="${cwd}backups"

logFile=.install_log
writeToLog=( tee -a "${logFile}" )
currentTime=$(date +%Y-%m-%d-%H-%M-%S)

# * rsync setup
optionsRS=(-avhz --delete)
bashFiles=(".bash_aliases" ".bashrc")

# * VIM setup
optionVI=(--yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
############################################################################

sudo echo -e "\nInstallation started!" | tee "${logFile}"
echo -e "Started at: $(date)" >> ${logFile}

# ? check and backup existing config files (opens subshell)
echo -e "\nChecking for existing files...\n" | ${writeToLog[@]}
existingBashFiles=(~/.bashrc ~/.bash_aliases ~/.vim ~/.vimrc)

if [ ! -d "${backupDir}" ]
then
    sudo mkdir "${backupDir}"
fi

for file in "${existingBashFiles[@]}"; do
    (
        if [ -f "${file}" ]
        then
            backupFile=${backupDir}${file#~}-${currentTime}.bak
            echo -e "   -> Found ${file}! Backing up to ${backupFile}" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} ${file} "${backupFile}" > /dev/null
        fi        
    )
done

if [ -d ~/.vim ]
then
    echo "   -> Found ~/.vim directory! Backing up to ${cwd}backups/.vim"
    sudo rsync ${optionsRS[@]} ~/.vim ${backupDir} > /dev/null 
    sudo rm -rf ~/.vim
fi

# ? rsync for copying all needed files
echo -e "\nProceeding to rsync bash files..." | ${writeToLog[@]}
for sourceFile in "${bashFiles[@]}"; do
    (
        sudo rsync ${optionsRS[@]} ${cwd}/bash/${sourceFile} ~ >> ${logFile}
    )
done
echo -e "Rsyncing bash files finished!" | ${writeToLog[@]}

# ? VI
echo -e "\nProceeding to VIM..." | ${writeToLog[@]}
read -p "Would you like to download vim? [Y/n]" -r responseOne
if [[ $responseOne =~ ^(yes|y|Y| ) ]] || [[ -z $responseOne ]];
then
    sudo apt-get ${optionVI[@]} install vim > /dev/null
    
    if [ ! -d ~/.vim ];
    then
        sudo mkdir ~/.vim
    fi
    
    sudo rsync ${optionsRS[@]} ${cwd}vim/ ~/.vim/ >> ${logFile}
    sudo rsync ${optionsRS[@]} ${cwd}vim/.vimrc ~ >> ${logFile}

    read -p "Would you like to download vim and set it as your default editor? [Y/n]" -r responseTwo
    responseTwo=${responseTwo,,} # tolower
    if [[ $responseTwo =~ ^(yes|y|Y| ) ]] || [[ -z $responseTwo ]];
    then
        echo "export VISUAL=vim" >> ~/.bashrc
        echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
    fi
fi
echo -e "\nVIM finished!\n" | ${writeToLog[@]}

echo -e "Ended at: $(date)" >> ${logFile}
echo -e "Installation finished!" | ${writeToLog[@]}
echo -e "Please open a new shell for changes to take effect!"
