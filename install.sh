#!/bin/bash

# This script serves as the main wrapper for executing
# all other scripts, i.e. the desktop or server
# installation of i3buntu.
#
# current version - 0.5.0 unstable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

# shellcheck source=resources/sys/sh/.bash_aliases
. "${SCR}/../sys/sh/.bash_aliases"

# ? Actual script

function usage() {
	cat 1>&2 <<EOF
Main install script for i3buntu 
version 1.2.0 unstable

USAGE:
	./install.sh [OPTIONS] COMMAND [FLAG]

OPTIONS:
	-h, --help      Shows help dialogue
	-v, --version   Shows current version of i3buntu and of used scripts

COMMANDS:
	 d, desktop     Start installation for desktops (packaging or configuration)
	 s, server      Start installation for servers (packaging and configuration)
	vm, vmware      Start installation of VM Ware Workstation Player

FLAGS:
	--pkg           For desktop installations; start packaging
	--cfg           For desktop installations; start configuration

EOF
}

function version() {
	cat 1>&2 <<EOF
i3buntu                       v1.2.00  unstable
install.sh                    v0.5.00  unstable
init.sh                       v0.1.07  unstable

x_packaging.sh                v1.4.00  unstable
x_configuration.sh            v1.2.00  unstable

server_packaging.sh           v1.5.00  unstable
server_configuration.sh       v1.0.00  unstable

extensions.sh                 v0.6.00  unstable
fonts.sh                      v0.5.00  unstable

vm.sh                         v0.3.00  stable

EOF
}

function say() {
	printf "%s" "$2"
	echo -e "$1"
}

function desktop() {
	case "$1" in
		"--pkg")
	        "${SCR}/x_packaging.sh"
		;;
	    
		"--cfg")
	        "${SCR}/x_configuration.sh"
	    ;;
	    
		*)
	    	err 'Please state whether you want packaging or configuration to happen'
			exit 20
		;;
	esac
}

function main() {
	case "$1" in 
	    "desktop" | "d")
	        desktop "$2"
	    	;;
	    "server" | "s")
	        "${SCR}/server_packaging.sh"
	    	;;
	    "vmware" | "vm")
	        "${SCR}/vm.sh"
	    	;;
	    "--version" | "-v")
	        version
	    	;;
	    "--help" | "-h")
	        usage
	    	;;
		"-i")
			say "Please choose whether your want a desktop or" "\n"
			say "server installation to happen [d/S]. If you"
			say "would like to stop here, type stop.\n"
			read -p "> " -r IC
			echo ''
			
			case $IC in
				"stop")
					echo ''
					exit
					;;
			
				"desktop" | "Desktop" | "d")
					./install.sh desktop --pkg < /dev/tty
					;;
			
				*)
					./install.sh server
					;;
			esac
			;;
		"")
			echo -e "i3buntu: You must provide a command"
	        echo -e "See './install --help'"
	        exit 1
			;;
	    *)
	        echo -e "i3buntu: '$1' is not a command."
	        echo -e "See './install --help'"
	        exit 10
	    	;;
	esac
}

main "$@" || exit 1
