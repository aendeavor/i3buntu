#!/bin/bash

# This script serves as the main wrapper for executing
# all other scripts, i.e. the desktop or server
# installation of i3buntu.
#
# current version - 0.4.2 unstable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/resources/scripts"

. "${SCR}/../sys/sh/.bash_aliases"

# ? Actual script

function usage() {
	cat 1>&2 <<EOF
Main install script for i3buntu 
version 1.0.13

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
i3buntu                       v1.0.13  unstable
install.sh                    v0.4.2   stable
i3buntu-init.sh               v0.1.4   unstable

x_packaging.sh                v1.2.0   unstable
x_configuration.sh            v1.0.0   unstable

server_packaging.sh           v1.3.2   stable
server_configuration.sh       v0.9.2   stable

extensions.sh                 v0.4.0   unstable
fonts.sh                      v0.3.1   stable

vm.sh                         v0.2.4   unstable

EOF
}

function say() {
	printf "$2"
	echo -e "		$1"
}

function desktop() {
	case "$1" in
		"--pkg")
	    	succ 'Packaging for desktops started'
	        "${SCR}/x_packaging.sh"
		;;
	    
		"--cfg")
	        succ 'Configuration for desktops started'
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
	        desktop $2
	    	;;
	    "server" | "s")
	        succ 'Server packaging and configuration started'
	        "${SCR}/server_packaging.sh"
	    	;;
	    "vmware" | "vm")
	        succ 'VM Ware Workstation player installation started'
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
			read -p "		> " -r IC
			
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
