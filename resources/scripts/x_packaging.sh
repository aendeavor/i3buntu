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
	nautilus
	python-nautilus
	nautilus-admin

    file-roller
    p7zip-full

    rofi

    policykit-desktop-privileges
    policykit-1-gnome
    gnome-keyring*
    libgnome-keyring0

    firefox
    thunderbird
    thunderbird-locale-de
    thunderbird-locale-en
)

ENV=(
    xorg
    xserver-xorg
    xbacklight

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
    
    tmux
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
function init() {
	if [[ ! -d "$BACK" ]]; then
	    mkdir -p "$BACK"
	fi

	if [[ ! -f "$LOG" ]]; then
	    if [[ ! -w "$LOG" ]]; then
	        &>/dev/null sudo rm $LOG
	    fi
	    touch "$LOG"
	fi
}

function choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r UDA
	read -p "Would you like to install OpenJDK? [Y/n]" -r OJDK
	read -p "Would you like to install Cryptomator? [Y/n]" -r CR
	read -p "Would you like to install TeX? [Y/n]" -r TEX
	read -p "Would you like to install ownCloud? [Y/n]" -r OC
	read -p "Would you like to install Build-Essentials? [Y/n]" -r BE
	read -p "Would you like to install NeoVIM? [Y/n]" -r NVIM
	read -p "Would you like to install VS Code? [Y/n]" -r VSC

	VSCE="no"
	if [[ $VSC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSC ]]; then
	    read -p "Would you like to install recommended VS Code extensions? [Y/n]" -r VSCE
	fi

	read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r JBIDE
	read -p "Would you like to install Docker? [Y/n]" -r DOCK
	read -p "Would you like to install RUST? [Y/n]" -r RUST
}

function prechecks() {
	_programs=( apt dpkg apt-get )
	for _program in "${_programs[@]}"; do
		if [[ -z $(which "${_program}") ]]; then
			err "Could not find program ${_program}\n\t\t\t\t\t\t\tAborting"
			exit 100
		fi
	done

	if [[ -z $(which gdm3) ]]; then
		warn 'It seems like GNOME (Display Manager 3) is installed. This would later conflict with LightDM and require user input'
		read 'Would you like to uninstall it? [y/N]' -p _uninstall_gnome

		if [[ $_uninstall_gnome =~ ^(yes|Yes|y|Y) ]]; then
			$_uninstall_gnome='true'
		else
			$_uninstall_gnome='false'
			warn 'This will require user input later'
		fi
	fi
}

function add_ppas() {
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

		local EC=$?
		if [[ $EC -ne 0 ]] && [[ $EC -ne 100 ]]; then
	    	warn "Something went wrong adding '$PPA'" "$LOG"
	    	inform 'You may try to add the PPA yourself (l. 170)'
	    	err 'Aborting'
	    	exit 2
	 	fi
	done
}

function packages() {
	inform "Installing packages\n" "$LOG"

	printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
	printf "\n"

	## needs to be checked first, as LightDM conflicts with these packages
	uninstall_and_log "${LOG}" liblightdm-gobject* liblightdm-qt*

	#! TESTING STARt

	case $_uninstall_gnome in
		'true')
			# gnome*
			uninstall_and_log "${LOG}" gdm3*
			>/dev/null 2>>"${LOG}" ${AI[@]} lightdm

			local EC=$?
	    	if (( $EC != 0 )); then
	        	printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
	    	else
	        	printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
	    	fi
	
	    	printf "\n"
	    	&>>"${LOG}" echo -e "${PACKAGE}\t -> EXIT CODE: ${EC}"
			;;
		'false')
			inform "Installing LightDM. Verbose output and user input necessarry\n"
			${AI[@]} lightdm

			echo ''
			local EC=$?
	    	if (( $EC != 0 )); then
	        	printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
	    	else
	        	printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
	    	fi
	
	    	printf "\n"
	    	&>>"${LOG}" echo -e "${PACKAGE}\t -> EXIT CODE: ${EC}"
			;;
	esac

	#! TESTING END

	for PACKAGE in "${PACKAGES[@]}"; do
	    >/dev/null 2>>"${LOG}" ${AI[@]} ${PACKAGE}

	    local EC=$?
	    if (( $EC != 0 )); then
	        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
	    else
	        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
	    fi
	
	    printf "\n"
	    &>>"${LOG}" echo -e "${PACKAGE}\t -> EXIT CODE: ${EC}"
	done

	uninstall_and_log "${LOG}" suckless-tools
	echo ""
}

## installs icon theme and colorpack
function icons_and_colors() {
	if [[ ! -d "${HOME}/.local/share/icons/Tela" ]]; then
	    inform 'Icon-Theme is being processed' "$LOG"
        (
          cd /tmp 
          wget\
            -O tela.tar.gz\
            "https://github.com/vinceliuice/Tela-icon-theme/archive/2020-02-21.tar.gz"\
            &>>/dev/null

          tar -xvzf "tela.tar.gz" &>>/dev/null
          mv Tela* tela
          cd /tmp/tela/
          ./install.sh -a &>> "${LOG}" 
        )
	fi

	(
		&>/dev/null mkdir -p "${HOME}/.themes"
		cp "${DIR}/../design/ant_dracula.tar" "${HOME}/.themes"
		cd "${HOME}/.themes"
		tar -xvf ant_dracula.tar &>/dev/null
	)

	succ 'Finished with actual script' "$LOG"
}

## processes user-choices from the beginning
function process_choices() {
	inform "Processing user-choices\n" "$LOG"

	## graphics driver
	if [[ $UDA =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $UDA ]]; then
		echo 'Enabling ubuntu-drivers autoinstall' | ${WTL[@]}
		&>>"${LOG}" sudo ubuntu-drivers autoinstall
	fi

	if [[ $OJDK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $OJDK ]]; then
		if [[ $(lsb_release -r) == *"18.04"* ]]; then
			echo 'Installing OpenJDK 11' | ${WTL[@]}
			>/dev/null 2>>"${LOG}" ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
		else
			echo 'Installing OpenJDK 12' | ${WTL[@]}
			>/dev/null 2>>"${LOG}" ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
		fi
	fi

	if [[ $CR =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $CR ]]; then
		echo 'Installing Cryptomator' | ${WTL[@]}
		&>>"${LOG}" sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
		&>>/dev/null sudo apt update
		>/dev/null 2>>"${LOG}" ${AI[@]} cryptomator
	fi

	if [[ $TEX =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $TEX ]]; then
		echo -e 'Installing TeX...' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} texlive-full
		>/dev/null 2>>"${LOG}" ${AI[@]} python3-pygments
	fi

	if [[ $OC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $OC ]]; then
		echo 'Installing ownCloud' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} owncloud-client
	fi

	if [[ $BE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $BE ]]; then
		echo 'Installing Build-Essential & CMake' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
	fi

	if [[ $NVIM =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $NVIM ]]; then
		echo -e 'Installing NeoVIM...' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} neovim
		>/dev/null 2>>"${LOG}" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

		echo ''
		inform 'You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell.'
		inform 'Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer --tern-completer.'
		echo 'n'
	fi

	if [[ $VSC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSC ]]; then
		echo 'Installing Visual Studio Code' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${SI[@]} code --classic
	fi

	if [[ $VSCE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSCE ]]; then
		echo -e "Installing Visual Studio Code Extensions\n" | ${WTL[@]}
		(
			"${DIR}/../sys/vscode/extensions.sh" | ${WTL[@]}
		)
        echo ''
	fi

	if [[ $JBIDE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $JBIDE ]]; then
		echo "Installing JetBrains' IDE suite" | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${SI[@]} intellij-idea-ultimate --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} kotlin --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} kotlin-native --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} pycharm-professional --classic
		>/dev/null 2>>"${LOG}" ${SI[@]} clion --classic
	fi

	if [[ $DOCK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $DOCK ]]; then
		echo -e 'Installing Docker' | ${WTL[@]}
		>/dev/null 2>>"${LOG}" ${AI[@]} docker.io
	fi

	if [[ $RUST =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RUST ]]; then
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

function post() {
	read -p "It is recommended to restart. Would you like to schedule a restart? [Y/n]" -r RESTART
	if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
	    shutdown --reboot 1 &>/dev/null
		inform 'Rebooting in one minute'
	fi
}

# ! Main

function main() {
    sudo printf ''
	inform 'Packaging has begun'
	init
	choices

	echo ""
	add_ppas

	inform 'Initial update' "$LOG"
	update &>${LOG}
	
	packages
	icons_and_colors
	process_choices

	succ 'Finished' "$LOG"
	post
}

main "$@" || exit 1
