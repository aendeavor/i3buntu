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
vimFiles=( ~/.vim ~/.vimrc )
XFiles=( ~/.Xresources )
i3Files=( "" )

# TODO i3-config still missing
deploymentFiles=( "$(pwd)/../resources/bash/.bashrc" "$(pwd)/../resources/bash/.bash_aliases" "$(pwd)/../resources/vim/.vim" "$(pwd)/../resources/vim/.vimrc" "$(pwd)/../resources/vim/.viminfo" "$(pwd)/../resources/X/.Xresources" )
fonts=( "$(pwd)/../resources/fonts/Iosevka Nerd" "$(pwd)/../resources/fonts/Open Sans" "$(pwd)/../resources/fonts/Roboto" "$(pwd)/../resources/fonts/Roboto Mono Nerd" )


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


${ece[@]} "\nDeployment of configuration files has begun!\n\nChecking for existing files...\n" | ${writeToLog[@]}

# ? Backup

# bash files
for file in ${bashFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done

# vim files
if [ -d $HOME/.vim ]
then
    ${ece[@]} "   -> Found $HOME/.vim directory!\n         Backing up to ${backupFile}\n" | ${writeToLog[@]}
    sudo rsync ${optionsRS[@]} ~/.vim ${backupDir} >> /dev/null 
    # ! sudo rm -rf ~/.vim
fi
for file in ${vimFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done

# Xresources
for file in ${XFiles[@]}; do
    (
        if [ -f ${file} ]; then
            backupFile=${backupDir}"${file#~}.bak"
            ${ece[@]} "   -> Found ${file}!\n         Backing up to ${backupFile}\n" | ${writeToLog[@]}
            sudo rsync ${optionsRS[@]} "${file}" "$(pwd)/${backupFile}" >> /dev/null
        fi
    )
done


# ? Deployment

echo -e "Proceeding to rsync bash files..." | ${writeToLog[@]}

for sourceFile in "${deploymentFiles[@]}"; do
    (
        ${ece[@]} "   -> Syncing $(basename -- "${sourceFile}")"
        sudo rsync ${optionsRS[@]} ${sourceFile} ~ >> /dev/null
    )
done

if [ ! -d ~/.fonts ]; then
    sudo mkdir ~/.fonts
fi

for sourceFile in "${fonts[@]}"; do
    (
        ${ece[@]} "   -> Syncing $(basename -- "${sourceFile}")"
        sudo rsync -avhz "${sourceFile}" ~/.fonts/ >> /dev/null
    )
done

xrdb ~/.Xresources



# ? User's choices

# vim
${ece[@]} ""
read -p "Would you like to set vim as your default editor? [Y/n]" -r responseOne
if [[ $responseOne =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $responseOne ]]; then
    echo "export VISUAL=vim" >> ~/.bashrc
    echo 'export EDITOR="$VISUAL"' >> ~/.bashrc
    ${ece[@]} "   -> Success!"
else
    ${ece[@]} ""
fi

read -p "Would you like me to edit /etc/default/grub? [Y/n]" -r responseTwo
if [[ $responseTwo =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $responseTwo ]]; then
    sudo rm -f /etc/default/grub
    sudo cp ../resources/others/grub /etc/default/
fi

${ece[@]} "\nDeployment of configuration files has ended. Installation finished! Please open a new shell for changes to take effect." | ${writeToLog[@]}
