#!/bin/bash

# This script serves as the main wrapper for executing
# all other scripts, i.e. the desktop, server or
# Docker installation of i3buntu.
#
# current version - 0.3.6 stable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

. "${SCR}/../sys/sh/.bash_aliases"

HELP="\nUsage: ./install.sh [OPTIONS] COMMAND [FLAG]\n\nDeployment script for i3buntu from where every installation and Docker build takes place\n\nCommands:\n d\t\033[0;31mdesktop\033[0m [FLAG]\tStart installation for desktops (packaging or configuration)\n s\t\033[1;32mserver\033[0m\t\tStart installation for servers (packaging and configuration)\n vm\t\033[1;33mvmware\033[0m\t\tStart installation of VM Ware Workstation Player\n\t\033[1;34mdocker\033[0m\t\tStart a Docker build and run\n\nFlags:\n\t--pkg\t\tFor desktop installations; specifies action to take (packaging)\n  \t--cfg\t\tFor desktop installations; specifies action to take (configuration)\n\nOptions:\n -h\t--help\t\tShows this help dialogue\n -v\t--version\tShows the current version of i3buntu and of the used scripts\n"

VERSION="i3buntu\t\t\tv0.9.2\t\tstable\ninstall.sh\t\tv0.3.4\t\tstable\n\nx_packaging\t\tv1.0.2\t\tstable\nx_configuration\t\tv0.9.1\t\tstable\n\nserver_packaging\tv1.1.1\t\tstable\nserver_configuration\tv0.8.0\t\tstable\n\ndocker_up\t\tv0.2.0\t\tstable\nget_docker\t\tv0.2.1\t\tstable\n\nextensions\t\tv0.2.1\t\tstable\nfonts\t\t\tv0.3.1\t\tstable\n"

# ? Actual script

case "$1" in 
        "docker")
            "${SCR}/../sys/docker/docker_up.sh"
        ;;
        "desktop" | "d")
            case "$2" in
                "--pkg")
                    succ 'Packaging for desktops started'
                    "${SCR}/x_packaging.sh"
                ;;
                "--cfg")
                    succ 'Configuration for desktops started'
                    "${SCR}/x_configuration.sh"
                ;;
                *)
                    inform 'Please state whether you want packaging or configuration to happen'
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
                        succ 'Packaging for desktops started'
                        "${SCR}/x_packaging.sh"
                    else
                        succ 'Configuration for desktops started'
                        "${SCR}/x_configuration.sh"
                    fi
                ;;
            esac
        ;;
        "server" | "s")
            succ 'Server packaging and configuration started'
            "${SCR}/server_packaging.sh"
        ;;
        "vm" | "vmware")
            succ 'VM Ware Workstation player installation started'
            "${SCR}/vm.sh"
        ;;
        "--version" | "-v")
            echo -e $VERSION
        ;;
        "--help" | "-h")
            echo -e $HELP
        ;;
        *)
            echo -e "i3buntu: '$1' is not a command."
            echo -e "See './install --help'"
            exit 10
        ;;
esac
