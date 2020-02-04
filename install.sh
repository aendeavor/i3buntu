#!/bin/bash

# This script serves as the main wrapper for executing
# all other scripts, i.e. the desktop, server or
# Docker installation of i3buntu.
#
# current version - 0.4.0 unstable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

. "${SCR}/../sys/sh/.bash_aliases"

# ? Actual script

help() {
	cat 1>&2 <<EOF
Main install script for i3buntu 
version 1.0.0

USAGE:
	./install.sh [OPTIONS] COMMAND [FLAG]

OPTIONS:
	-h, --help		Shows help dialogue
	-v, --version	Shows current version of i3buntu and of used scripts

COMMANDS:
	desktop			Start installation for desktops (packaging or configuration)
	server			Start installation for servers (packaging and configuration)
	vmware			Start installation of VM Ware Workstation Player

FLAGS:
	--pkg			For desktop installations; start packaging
	--cfg			For desktop installations; start configuration
EOF
}

version() {
	cat 1>&2 <<EOF
i3buntu					v0.9.2	stable
install.sh				v0.4.0	unstable

x_packaging.sh			v1.1.0	unstable
x_configuration			v0.9.1	stable

server_packaging		v1.2.0	unstable
server_configuration	v0.8.0	stable

extensions				v0.2.1	stable
fonts					v0.3.1	stable

vm.sh					v0.2.2	unstable
EOF
}

main() {
	case "$1" in 
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
	        version
	    ;;
	    "--help" | "-h")
	        help
	    ;;
	    *)
	        echo -e "i3buntu: '$1' is not a command."
	        echo -e "See './install --help'"
	        exit 10
	    ;;
	esac
}

main "$@" || exit 1
