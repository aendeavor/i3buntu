#!/bin/bash

# This script serves as the main wrapper for executing
# all other scripts, i.e. the desktop, server or
# Docker installation of i3buntu.
#
# current version - 0.1.0

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

. "${SCR}/../sys/sh/.bash_aliases"

# ? Actual script

case "$1" in 
        "--docker")
            succ 'A Docker container will be setup.'
            "${SCR}/../sys/docker/docker_up.sh"
        ;;
        "--desktop" | "-d")
            case "$2" in
                "pkg")
                    succ 'Packaging for desktops will be executed.'
                    "${SCR}/x_packaging.sh"
                ;;
                "cfg")
                    succ 'Configuration for desktops will be executed.'
                    "${SCR}/x_configuration.sh"
                ;;
                *)
                    warn 'Please state whether you want packaging or configuration to happen.'
                    while true; do
                        read -p "Would you like to execute packaging or configuration? [pkg/cfg]" -r PAR
                        if [[ $PAR =~ ^(cfg|pkg) ]]; then
                            break
                        else
                            warn 'Could not identify input. Try again.'
                            continue
                        fi
                    done

                    if [[ $PAR == "pkg" ]]; then
                        succ 'Packaging for desktops will be executed.'
                        "${SCR}/x_packaging.sh"
                    else
                        succ 'Configuration for desktops will be executed.'
                        "${SCR}/x_configuration.sh"
                    fi
                ;;
            esac
        ;;
        "--server" | "-s")
            succ 'Server packaging and configuration will be setup.'
            "${SCR}/server_packaging.sh"
        ;;
        "--version" | "-v")
            echo -e "i3buntu\t\tversion  v0.9.2-beta.1 unstable"
            echo -e "This script\tversion  v0.1.0"
            ;;
        *)
            err 'Please consult INSTALL.md on how to use this script.'
            exit 1
        ;;
esac
