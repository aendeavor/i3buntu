#!/usr/bin/env bash
# This script serves as a wrapper for installing
# the latest version of Docker.
# 
# version   0.2.1 stable
# source    https://github.com/docker/docker-install

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
## return pointer
RIP=$1

# initiate aliases and functions
. "${SCR}/../sh/.bash_aliases"

# ? Checks

if [[ -n $(which docker) ]]; then
    warn 'Docker seems to be already installed'
    read -p "Would you like to abort the installation of Docker? (This wont affect the calling script.) [Y/n]" -r R1
    
    if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
        exit 0
    fi

    warn 'There is going to be a delay of approximately 20s. Hang on...'
fi

# ? Actual script

## go into this folder to handle temporaries
cd $SCR

&>>/dev/null curl -sSL https://get.docker.com -o docker_installer.sh
sh docker_installer.sh &>>/dev/null

if (( $? == 0 )); then
    succ 'Docker successfully installed'
else
    err 'Docker not successfully installed'
    exit 1
fi

cd $SCR
rm docker_installer.sh

## return from where we were called from
cd $RIP
