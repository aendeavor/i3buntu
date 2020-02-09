#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# version   1.2.0 unstable

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )
WTL=( tee -a "${LOG}" )

## initiate aliases and functions
. "${DIR}/../sys/sh/.bash_aliases"

# ? Init of package selection

CRITICAL=(
    ubuntu-drivers-common
    intel-microcode
    curl
    wget
    libaio1

    net-tools
    network-manager*
    
    python3-distutils
    snapd

    rxvt-unicode
    vim

    nemo
    ranger
    file-roller
    p7zip-full

    rofi

    policykit-desktop-privileges
    policykit-1-gnome
    gnome-keyring*
    libgnome-keyring0

    firefox
    thunderbird
)

ENV=(
    xorg
    xserver-xorg
    xbacklight

    lightdm
	slick-greeter
    
    i3-gaps
	i3status
    i3lock

    feh
    compton
    
    mesa-utils
    mesa-utils-extra

    gtk2-engines-pixbuf
    gtk2-engines-murrine
    
    lxappearance
    arandr

    pulseaudio
    gstreamer1.0-pulseaudio
    pulseaudio-module-raop
    pulseaudio-module-bluetooth
)

MISC=(
    xsel
    xclip

    ruby
    python2.7-dev

    neofetch
    htop

    fonts-roboto
    fonts-open-sans
    fonts-lyx

    gparted

    fontconfig
    compton-conf
    
    evince
    gedit
    nomacs
    
    scrot
    qalculate
	ripgrep 		# available in 18.10 and later

	alacritty
)

PACKAGES=( "${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}" )

# ? Actual script

## init of backup-directory and logfile
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

## user-choices
choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
	read -p "Would you like to install OpenJDK? [Y/n]" -r R2
	read -p "Would you like to install Cryptomator? [Y/n]" -r R3
	read -p "Would you like to install Balena Etcher? [Y/n]" -r R4
	read -p "Would you like to install TeX? [Y/n]" -r R5
	read -p "Would you like to install ownCloud? [Y/n]" -r R6
	read -p "Would you like to install Build-Essentials? [Y/n]" -r R7
	read -p "Would you like to install NeoVIM? [Y/n]" -r R8
	read -p "Would you like to install VS Code? [Y/n]" -r R9

	RC1="no"
	if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
	    read -p "Would you like to install recommended VS Code extensions? [Y/n]" -r RC1
	fi

	read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r R10
	read -p "Would you like to install Docker? [Y/n]" -r R11
	read -p "Would you like to install RUST? [Y/n]" -r R12
}

## adds PPAs if necessary
add_ppas() {
	local ppas=(
		ppa:git-core/ppa
		ppa:ubuntu-mozilla-security/ppa
		ppa:kgilmer/speed-ricer
		ppa:mmstick76/alacritty
	)

	inform 'Adding necessary PPAs'

	&>>/dev/null ${AI[@]} software-properties-common

	for PPA in ${ppas[@]}; do
		sudo add-apt-repository -y "$PPA" &>/dev/null

		if (( $? != 0 )); then
	    	warn "Something went wrong adding '$PPA'" "$LOG"
	    	inform 'You may try to add the PPA yourself (l. 170)'
	    	err 'Aborting'
	    	exit 2
	 	fi
	done
}

## (un-)install all packages with APT
packages() {
	inform "Installing packages\n" "$LOG"

	printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
	printf "\n"

	## needs to be checked first, as LightDM conflicts with these packages
	uninstall_and_log "${LOG}" liblightdm-gobject* liblightdm-qt*

	for PACKAGE in "${PACKAGES[@]}"; do
	    >/dev/null 2>>"${LOG}" ${AI[@]} ${PACKAGE}

	    EC=$?
	    if (( $EC != 0 )); then
	        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
	    else
	        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
	    fi
	
	    printf "\n"
	    &>>"${LOG}" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
	done

	uninstall_and_log "${LOG}" suckless-tools
	echo ""
}

## installs icon theme and colorpack
icons_and_colors() {
	if [[ ! -d "${HOME}/.local/share/icons/Tela" ]]; then
	    inform 'Icon-Theme is being processed' "$LOG"
	    (
	        cd "${DIR}/../icon_theme"
	        &>>"${LOG}" find . -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
	        &>>"${LOG}" ./icon_theme.sh "$LOG"
	    )
	fi

	if ! dpkg -s adapta-gtk-theme-colorpack &>/dev/null; then
	    inform 'Color-Pack is being processed' "$LOG"
	    >/dev/null 2>>"${LOG}" sudo dpkg -i "${DIR}/../design/AdaptaGTK_colorpack.deb"
	fi

	succ 'Finished with actual script' "$LOG"
}

## processes user-choices from the beginning
process_choices() {
	inform "Processing user-choices\n" "$LOG"

	## graphics driver
	if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
		echo 'Enabling ubuntu-drivers autoinstall' | ${WTL[@]}
		&>>"${LOG}" sudo ubuntu-drivers autoinstall
	fi

	if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
		if [[ $(lsb_release -r) == *"18.04"* ]]; then
			echo 'Installing OpenJDK 11' | ${WTL[@]}
			>/dev/null 2>>"${LOG}" ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
		else
			echo 'Installing OpenJDK 12' | ${WTL[@]}
			>/dev/null 2>>"${LOG}" ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
		fi
	fi

	if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
		echo 'Installing Cryptomator' | ${WTL[@]}
		&>>"${LOG}" sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
		&>>/dev/null sudo apt update
		>/dev/null 2>>"${LOG}" ${AI[@]} cryptomator
	fi

	if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
		echo 'Installing Etcher Electron' | ${WTL[@]}
		if [[ ! -e /etc/apt/sources.list.d/balena-etcher.list ]]; then
			sudo touch /etc/apt/sources.list.d/balena-etcher.list
		fi

		echo "deb https://deb.etcher.io stable etcher" | >/dev/null sudo tee /etc/apt/sources.list.d/balena-etcher.list
		&>>"${LOG}" sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
		&>>/dev/null sudo apt update
		>/dev/null 2>>"${LOG}" ${AI[@]} balena-etcher-electron
	fi

	if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
		echo -e 'Installing TeX...' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} texlive-full
		>/dev/null 2>>"${LOG}" ${AI[@]} python3-pygments
	fi

	if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
		echo 'Installing ownCloud' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} owncloud-client
	fi

	if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
		echo 'Installing Build-Essential & CMake' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
	fi

	if [[ $R8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R8 ]]; then
		echo -e 'Installing NeoVIM...' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" sudo apt-get install neovim
		>/dev/null 2>>"${LOG}" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

		inform 'You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell.'
		inform 'Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer --tern-completer.'
		sleep 3s
	fi

	if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
		echo 'Installing Visual Studio Code' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${SI[@]} code --classic
	fi

	if [[ $RC1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC1 ]]; then
		echo 'Installing Visual Studio Code Extensions' | ${WTL[@]}
		(
			&>>"${LOG}" "${DIR}/../sys/vscode/extensions.sh"
		)
	fi

	if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
		echo "Installing JetBrains' IDE suite" | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${SI[@]} intellij-idea-ultimate --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} kotlin --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} kotlin-native --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} pycharm-professional --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} clion --classic
	fi

	if [[ $R11 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R11 ]]; then
		echo -e 'Installing Docker' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} docker.io
	fi

	if [[ $R12 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R12 ]]; then
		echo -e "Installing RUST" | ${WTL[@]}

		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete -y &>/dev/null

		if [[ -e "${HOME}/.cargo/env" ]]; then
			source "${HOME}/.cargo/env"

			mkdir -p "${HOME}/.local/share/bash-completion/completions"
			touch "${HOME}/.local/share/bash-completion/completions/rustup"
			rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

			COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
			for COMPONENT in ${COMPONENTS[@]}; do
				&>>"${LOG}" rustup component add $COMPONENT
			done

			if [[ ! -z $(which code) ]]; then
				code --install-extension rust-lang.rust >/dev/null 2>>${LOG}
			fi

			>/dev/null 2>>"${LOG}" rustup update
		fi
	fi

	succ 'Finished with processing user-choices' "$LOG"
}

## postconfiguration
post() {
	read -p "It is recommended to restart. Would you like to schedule a restart? [Y/n]" -r RESTART
	if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
	    shutdown --reboot 1 >/dev/null
		inform 'Rebooting in one minute'
	fi
}

# ! Main

main() {
	sudo inform 'Packaging has begun'
	init
	choices

	echo ""
	add_ppas

	inform 'Initial update' "$LOG"
	update
	
	packages
	icons_and_colors
	process_choices

	succ 'Finished' "$LOG"
	post
}

main "$@" || exit 1
