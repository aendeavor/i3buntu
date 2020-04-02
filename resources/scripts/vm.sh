#!/usr/bin/env bash

# This script serves the installation
# of the VM Ware Workstation Player
# for Linux maschines.
#
# version 0.3.0 stable

# Install VM Ware Workstation Player, if
# not already installed
function install_vmware_player() {
	if [[ -n $(which vmplayer) ]]; then
	  	echo -e "VM Ware Workstation Player already installed"
	else
		sudo apt update &>/dev/null
		sudo apt install build-essential linux-headers-generic &>/dev/null	
		
		cd /tmp
		wget --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/70.0" https://www.vmware.com/go/getplayer-linux -qy
		
		chmod a+x getplayer-linux &>/dev/null
		sudo ./getplayer-linux &>/dev/null
	fi
}

function edit_sudoers() {
	# Make VM Ware Workstation Player executable with sudo without
	# needing to enter the password of the current user

	if [[ -e "/etc/sudoers.d/vmware" ]]; then
	  sudo mv /etc/sudoers.d/vmware /etc/sudoers.d/vmware_old
	fi

	sudo touch /etc/sudoers.d/vmware

	echo '# Execute VM Ware Workstation Player as sudo without password' | (sudo su -c 'EDITOR="tee -a" visudo -f /etc/sudoers.d/vmware') &>/dev/null
	echo -e "$(whoami) ALL=NOPASSWD:/usr/bin/vmplayer" | (sudo su -c 'EDITOR="tee -a" visudo -f /etc/sudoers.d/vmware') &>/dev/null

	succ 'VM Ware Workstation Player installed'

	read -p "It is recommended to restart. Would you like to schedule a restart? [Y/n]" -r RESTART
	if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
	    shutdown --reboot 1 &>/dev/null
		inform 'Rebooting in one minute'
	fi
}

# ! Main

function main() {
	sudo printf ''
	install_vmware_player
	edit_sudoers
}

main "$@" || exit 1

