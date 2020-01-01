#!/usr/bin/env bash
# This script serves as a wrapper for installing
# the latest version of Docker.
# 
# version   0.0.1
# source    https://github.com/docker/docker-install

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
## return pointer
RIP=$1

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
NC='\033[0m'        # NO COLOR

# ? Checks

if [[ $(docker -v) =~ ^Docker\ version\ [1-9.]* ]]; then
    echo -e "${YEL}WARNING${NC}\tDocker seems to be already installed."
    read -p "Would you like to abort the installation of Docker? (This wont affect the calling script.) [Y/n]" -r R1
    
    if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
        exit 0
    fi
fi

# ? Actual script

## go into this folder to handle temporaries
cd $SCR

curl -sSL https://get.docker.com -o docker_installer.sh
sh docker_installer.sh
rm docker_installer.sh

curl -fsSL https://test.docker.com -o docker_installer_test.sh
sh docker_installer_test.sh
rm docker_installer_test.sh

## return from where we were called from
cd $RIP
