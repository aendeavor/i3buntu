#!/bin/bash

# This script serves as a wrapper for executing
# all other scripts, i.e. the desktop, server or
# Docker installation of i3buntu.
#
# current version - 0.0.1

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
NC='\033[0m'        # NO COLOR

# ? Actual script

case "$1" in 
        "--docker")
            echo -e "${GRE}SUCCESS${NC}\tDocker will be setup."
            "${SCR}/docker_up.sh"
        ;;
        "--desktop")
            case "$2" in
                "pkg")
                    echo -e "${GRE}SUCCESS${NC}\tPackaging for desktops will be executed."
                    "${SCR}/x_packaging.sh"
                ;;
                "cfg")
                    echo -e "${GRE}SUCCESS${NC}\tConfiguration for desktops will be executed."
                    "${SCR}/x_configuration.sh"
                ;;
                *)
                    echo -e "${YEL}WARNING${NC}\tPlease state whether you want packaging or configuration to happen."
                    while true; do
                        read -p "Would you like to execute packaging or configuration? [pkg/cfg]" -r PAR
                        if [[ $PAR =~ ^(cfg|pkg) ]]; then
                            break
                        else
                            echo -e "${YEL}WARNING${NC}\tCould not identify input. Try again."
                            continue
                        fi
                    done

                    if [[ $PAR == "pkg" ]]; then
                        echo -e "${GRE}SUCCESS${NC}\tPackaging for desktops will be executed."
                        "${SCR}/x_packaging.sh"
                    else
                        echo -e "${GRE}SUCCESS${NC}\tConfiguration for desktops will be executed."
                        "${SCR}/x_configuration.sh"
                    fi
                ;;
            esac
        ;;
        "--server")
            echo -e "${GRE}SUCCESS${NC}\tServer packaging and configuration will be setup."
            "${SCR}/server_packaging.sh"
        ;;
        *)
            echo -e "${RED}ERROR${NC}\tPlease consult INSTALL.md on how to use this script."
            exit 1
        ;;
esac
