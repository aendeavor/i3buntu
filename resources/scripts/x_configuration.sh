#!/bin/bash

# This script serves as the main post-packaging
# script, i.e. it backups existing config files
# and deploys new and correct version from this
# repository.
# Furthermore, reloading of services and some
# user-choices are handled, including the
# installation of chosen fonts.
# 
# current version - 1.1.17 stable

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../../backups/configuration/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/configuration_log"

RS=( rsync -ahq --delete )
WTL=( tee -a "${LOG}" )

# initiate aliases and functions
. "${SYS}/sh/.bash_aliases"

# ? Actual script

## user-choices
choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to edit /etc/default/grub? [Y/n]" -r GRUB
	read -p "Would you like to sync fonts? [Y/n]" -r FONTS
	echo ''
}

## init of backup-directory
init() {
	if [[ ! -d "$BACK" ]]; then
		mkdir -p "$BACK"
	fi

	## init of logfile
	if [[ ! -f "$LOG" ]]; then
		if [[ ! -w "$LOG" ]]; then
			&>/dev/null sudo rm $LOG
		fi
		touch "$LOG"
	fi
}

##backup of configuration files
backup() {
	inform "Checkig for existing files\n" "$LOG"
	_home_files=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" "${HOME}/.Xresources" )
	for _file in ${_home_files[@]}; do
		if [[ -f "$_file" ]]; then
			_backup_file="${BACK}${_file#~}.bak"
			echo -e "-> Found ${_file}... backing up" | ${WTL[@]}
			# echo -e "\tBacking up to ${_backup_file}"
			>/dev/null 2>>"${LOG}" sudo ${RS[@]} "$_file" "$_backup_file"
		fi
	done

	if [[ -d "${HOME}/.vim" ]]; then
		echo -e "-> Found ~/.vim directory... backing up" | ${WTL[@]}
		# echo -e "Backing up to ${BACK}/.vim"
		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.vim" "${BACK}"
		rm -rf "${HOME}/.vim"
	fi

	if [ -d "${HOME}/.config" ]; then
		echo -e "-> Found ${HOME}/.config directory... backing up" | ${WTL[@]}
		# echo -e "Backing up to ${BACK}/.config"
		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.config/i3" "${BACK}"
	fi
}

## deployment of configuration files
deploy() {
	echo ''
	inform "Proceeding to deploying config files\n" "$LOG"
	
	local _deploy_in_home=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo Xi3/.Xresources )
	for sourceFile in "${_deploy_in_home[@]}"; do
	    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
	    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
	done
	
	mkdir -p "${HOME}/.config/i3" "${HOME}/.urxvt/ext" "${HOME}/images" "${HOME}/.config/alacritty" "${HOME}/.local/share/nemo/actions" "${HOME}/images" "${HOME}/.config/rofi" "${HOME}/.local/share/nautilus-python/extensions"
	sudo mkdir -p /usr/share/lightdm /etc/lightdm /usr/share/backgrounds
	
	echo -e "-> Syncing i3's config" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/config" "${HOME}/.config/i3"
	
	echo -e "-> Syncing i3's statusconfig" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/Xi3/i3statusconfig" "${HOME}/.config/i3"
	
	echo -e "-> Modifying xorg.conf" | ${WTL[@]}
	if [[ ! -e /etc/X11/xorg ]]; then
		sudo touch /etc/X11/xorg.conf
	fi
	if [[ $(cat /etc/X11/xorg.conf) != *$(cat "${DIR}/../sys/Xi3/xorg.conf")* ]]; then
		cat "${DIR}/../sys/Xi3/xorg.conf" | sudo tee -a /etc/X11/xorg.conf >/dev/null
	fi
	
	echo -e "-> Syncing lightdm configuration" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/other_cfg/lightdm.conf" /etc/lightdm
	>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/other_cfg/slick-greeter.conf" /etc/lightdm

	echo -e "-> Syncing lightdm wallpaper" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${RES}/design/macOS_HighSierra.png" /usr/share/lightdm

	echo -e "-> Syncing Rofi's configuration" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/other_cfg/config.rasi" "${HOME}/.config/rofi"

	echo -e "-> Syncing URXVT resize-font extension" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/resize-font" "${HOME}/.urxvt/ext"

	echo -e "-> Syncing compton.conf" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/other_cfg/compton.conf" "${HOME}/.config"

	echo -e "-> Syncing alacritty.yml" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/alacritty.yml" "${HOME}/.config/alacritty"

	echo -e "-> Syncing wallpaper" | ${WTL[@]}
	>/dev/null 2>>"${LOG}" ${RS[@]} "${RES}/design/macOS_HighSierra.jpg" "${HOME}/images"

	if [[ -d "${HOME}/.config/Code" ]]; then
	    echo -e "-> Syncing VS Code settings" | ${WTL[@]}
	    sudo mkdir -p "${HOME}/.config/Code/User"
	    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vscode/settings.json" "${HOME}/.config/Code/User"
	fi

    echo -e '-> Copying PowerLine-Go to /bin'
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/powerline-go-linux-amd64" "/bin"
	
	if dpkg -s neovim &>/dev/null; then
		mkdir -p "${HOME}/.config/nvim"
		sudo mkdir -p "/root/.config/nvim"
		echo -e "-> Syncing NeoVIM's configuration"
		>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/.vimrc" "${HOME}"
		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/vi/.vimrc" "/root"

		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/vi/init.vim" "/root/.config/nvim"
		>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/init.vim" "${HOME}/.config/nvim"

    	>/dev/null 2>>"${LOG}" curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    	>/dev/null 2>>"${LOG}" curl -fLo '/root/.local/share/nvim/site/autoload/plug.vim' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

		echo ''
		warn "You will need to run :PlugInstall seperately in NeoVIM\n\t\t\t\t\tas you cannot execute this command in a shell.\n\t\t\t\t\tThereafter, run python3 ~/.config/nvim/plugged/YouCompleteMe/install.py"
	else
		echo ''
	fi

	inform 'Reloading X-services'
	&>/dev/null xrdb ${HOME}/.Xresources

    inform 'Nemo is being configured...' "$LOG"
    xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
   	gsettings set org.cinnamon.desktop.default-applications.terminal exec 'alacritty'
   	gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e
   	gsettings set org.gnome.desktop.background show-desktop-icons false
   	gsettings set org.nemo.desktop show-desktop-icons true
	
   	cp -f "${SYS}/filemanagers/vscode-current-dir.nemo_action" "${HOME}/.local/share/nemo/actions/"
	cp -f "${SYS}/filemanagers/nautilus-terminal.py" "${HOME}/.local/share/nautilus-python/extensions/"
	cp -f "${SYS}/filemanagers/nautilus-code.py" "${HOME}/.local/share/nautilus-python/extensions/"
}

## processes user-choices from the beginning
process_choices() {
	inform "Processing user-choices" "$LOG"

	if [[ $GRUB =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $GRUB ]]; then
	    inform 'Grub is being configured...' "$LOG"
	    &>/dev/null sudo cp /etc/default/grub "${BACK}"
	    &>/dev/null sudo rm -f /etc/default/grub
	    &>/dev/null sudo cp ${RES}/sys/other_cfg/grub /etc/default/
	    >/dev/null 2>>"${LOG}" sudo update-grub
	fi

	if [[ $FONTS =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $FONTS ]]; then
	    inform "Fonts are processed\n" "$LOG"
	    "${DIR}/fonts.sh"
	    >/dev/null 2>>"${LOG}" fc-cache -f
	fi

	succ 'Finished with processing user-choices' "$LOG"
}

post() {
	if [[ -z $(which shutdown) ]]; then
		warn 'Altough recommended, could not find shutdown to restart'
		return 1
	fi

	echo ''
	read -p "It is recommended to restart now. Would you like to restart? [Y/n]" -r RESTART
	if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
	    shutdown --reboot 1 >/dev/null
        inform 'Rebooting in one minute'
	fi
}

# ! Main

main() {
    sudo printf ''
	inform 'Desktop configuration has begun'

	init
	choices

	backup
	deploy
	process_choices

	succ 'Finished configuraton stage' "$LOG"
	post
}

main "$@"
