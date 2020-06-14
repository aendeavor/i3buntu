#!/bin/bash


function choices() {
	inform "Please make your choices:\n"

	read -p 'Would you like to execute ubuntu-driver autoinstall? [Y/n]' -r UDA
	read -p 'Would you like to install OpenJDK? [Y/n]' -r OJDK
	read -p 'Would you like to install Cryptomator? [Y/n]' -r CR
	read -p 'Would you like to install VS Code? [Y/n]' -r VSC

	VSCE="no"
	if [[ $VSC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSC ]]; then
	    read -p 'Would you like to install recommended VS Code extensions? [Y/n]' -r VSCE
	fi

	read -p 'Would you like to install the JetBrains IDE suite? [Y/n]' -r JBIDE
	
	DOCK="n"
	[ -z "$(command -v docker)" ] && read -p "Would you like to install Docker? [Y/n]" -r DOCK

	read -p 'Would you like to install RUST? [Y/n]' -r RUST

	echo ''
}

function prechecks() {
	_programs=( apt dpkg apt-get )
	for _program in "${_programs[@]}"; do
		if [[ -z $(command -v "${_program}") ]]; then
			err "Could not find command ${_program}\n\t\tAborting." | "${WTL[@]}"
			exit 100
		fi
	done
}

function check_lightdm() {
    _uninstall_gnome='normal'
	if [[ -n $(command -v gdm3) ]]; then
		warn 'It seems like GNOME (GDM3) is installed.\n\t\t\tThis can later conflict with LightDM and require user input.\n'
		read -p 'Would you like to uninstall it? [y/N]' -r _uninstall_gnome

		echo ''
		if [[ $_uninstall_gnome =~ ^(yes|Yes|y|Y) ]]; then
			_uninstall_gnome='true'
		else
			_uninstall_gnome='false'
			warn 'This could require user input later'
		fi
	fi
}

function add_ppas() {
	local _ppas=(
		ppa:git-core/ppa
		ppa:ubuntu-mozilla-security/ppa
		ppa:kgilmer/speed-ricer
		ppa:mmstick76/alacritty
	)

	inform 'Adding necessary PPAs' | "${WTL[@]}"

	ensure "${AI[@]}" software-properties-common >/dev/null

	for _ppa in "${_ppas[@]}"; do
		ensure sudo add-apt-repository -y "$_ppa" >/dev/null
	done
}

function uninstall_and_log()
{
    local LOG=${1:-"/dev/null"}
    shift

    local IF=(
        --yes
        --allow-unauthenticated
        --allow-downgrades
        --allow-remove-essential
        --allow-change-held-packages
        -qq
    )

    # cannot just use $*, because when logging, we need to do
    # it iteratively, so we use $@
    for PACKAGE in "$@"; do
        >/dev/null 2>>"${LOG}" sudo apt-get remove "${IF[@]}" "$PACKAGE"
        EC=$?

        if (( EC != 0 )); then
            printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Removed" "${EC}"
        else
            printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Removed" "${EC}"
        fi
        printf "\n"

        echo -e "${PACKAGE} (${EC})" &>>"$LOG"
    done
}

function packages() {
	inform "Installing packages\n" "$LOG"

	printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
	printf "\n"

	# needs to be checked first, as LightDM conflicts with these packages
	ensure uninstall_and_log "${LOG}" liblightdm-gobject* liblightdm-qt*

	case $_uninstall_gnome in
		'true')
			ensure uninstall_and_log "${LOG}" gdm3* # gnome*
			ensure "${AI[@]}" lightdm >/dev/null
			;;
		'false')
			echo ''
			inform "Installing LightDM. Verbose output and user input might necessarry\n"
			ensure "${AI[@]}" lightdm
            echo ''
            ;;
        'normal')
	        >/dev/null 2>>"${LOG}" "${AI[@]}" lightdm
            ;;
    esac

	local EC=$?
	if (( EC != 0 )); then
    	printf "%-35s | %-15s | %-15s" "lightdm" "Not Installed" "${EC}"
	else
    	printf "%-35s | %-15s | %-15s" "lightdm" "Installed" "${EC}"
	fi

	printf "\n"
	echo -e "lightdm (${EC})" &>>"${LOG}"

	for _package in "${PACKAGES[@]}"; do
	    >/dev/null 2>>"${LOG}" "${AI[@]}" "${_package}"

	    local EC=$?
	    if (( EC != 0 )); then
	        printf "%-35s | %-15s | %-15s" "${_package}" "Not Installed" "${EC}"
	    else
	        printf "%-35s | %-15s | %-15s" "${_package}" "Installed" "${EC}"
	    fi
	
	    printf "\n"
	    echo -e "${_package} (${EC})" &>>"${LOG}"
	done

	uninstall_and_log "${LOG}" suckless-tools
	echo '' | "${WTL[@]}"
	succ "Finished with packaging" "$LOG"
}

## installs icon theme and colorpack
function icons_and_colors() {
	if [[ ! -d "${HOME}/.local/share/icons/Tela" ]]; then
	    inform 'Icon-Theme is being processed' "$LOG"
        (
          cd /tmp || exit 1
          wget\
            -O tela.tar.gz\
            "https://github.com/vinceliuice/Tela-icon-theme/archive/2020-05-12.tar.gz" >/dev/null || exit 1

          tar -xvzf "tela.tar.gz" &>>/dev/null
          mv Tela* tela
          cd /tmp/tela/ || return 1
          ./install.sh grey >/dev/null 2>>"${LOG}"
        )
	fi

	(
		mkdir -p "${HOME}/.themes" &>/dev/null
		cp "${DIR}/../design/nordic_darker.tar.xz" "${HOME}/.themes"
		cd "${HOME}/.themes" || return 1
		tar -xf nordic_darker.tar &>/dev/null
	)
}

## processes user-choices from the beginning
function process_choices() {
	inform "Processing user-choices" "$LOG"

	if [[ $UDA =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $UDA ]]; then
		printf '\nEnabling ubuntu-drivers autoinstall... ' | "${WTL[@]}"
		test_on_success "$LOG" sudo ubuntu-drivers autoinstall
	fi

	if [[ $OJDK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $OJDK ]]; then
        local jv=14
		if [[ $(lsb_release -r) == *"18.04"* ]]; then
			printf '\nInstalling OpenJDK 11... ' | "${WTL[@]}"
            jv=11
		else
			printf '\nInstalling OpenJDK 14... ' | "${WTL[@]}"
		fi

		test_on_success "$LOG" "${AI[@]}" openjdk-${jv}-jdk openjdk-${jv}-doc openjdk-${jv}-jre-headless openjdk-${jv}-source
	fi

	if [[ $CR =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $CR ]]; then
		printf '\nInstalling Cryptomator... ' | "${WTL[@]}"
		sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator &>>/dev/null
		
		local RSP=$?
		if [ $RSP -ne 0 ]; then
			err "Could not add Cryptomator PPA\n\t\tSkipping"
		else
			&>>/dev/null sudo apt update
			test_on_success "$LOG" "${AI[@]}" cryptomator
		fi
	fi

	if [[ $TEX =~ ^(yes|Yes|y|Y| ) ]] || [ -z "$TEX" ]; then
		printf '\nInstalling TeX... ' | "${WTL[@]}"
	    "${AI[@]}" python3-pygments &>/dev/null
		test_on_success "$LOG" "${AI[@]}" texlive-full
	fi

	if [[ $OC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $OC ]]; then
		printf '\nInstalling ownCloud... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" owncloud-client
	fi

	if [[ $BE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $BE ]]; then
		printf '\nInstalling Build-Essential & CMake... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" build-essential cmake
	fi

	if [[ $NVIM =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $NVIM ]]; then
		printf '\nInstalling NeoVIM... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" neovim
	fi

	if [[ $VSC =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSC ]]; then
		printf '\nInstalling Visual Studio Code... ' | "${WTL[@]}"
		test_on_success "$LOG" "${SI[@]}" code --classic
	fi

	if [[ $VSCE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $VSCE ]]; then
		printf '\nInstalling Visual Studio Code Extensions... ' | "${WTL[@]}"
		test_on_success "$LOG" "${DIR}/../sys/vscode/extensions.sh"
	fi

	if [[ $JBIDE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $JBIDE ]]; then
		printf "\nInstalling JetBrains' IDE suite" | "${WTL[@]}"
		printf '\n  –> IntelliJ Ultimate... '
		test_on_success "$LOG" "${SI[@]}" intellij-idea-ultimate --classic
		
		printf '\n  –> PyCharm Professional... '
		test_on_success "$LOG" "${SI[@]}" pycharm-professional --classic

		printf '\n  –> CLion... '
		test_on_success "$LOG" "${SI[@]}" clion --classic
	fi

	if [[ $DOCK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $DOCK ]]; then
		printf '\nInstalling Docker... ' | "${WTL[@]}"
    	test_on_success "$LOG" "${AI[@]}" docker.io
        sudo systemctl enable --now docker >/dev/null 2>>"$LOG"
		sudo usermod -aG docker "$(whoami)" &>/dev/null

        local _compose_version="1.26.0"
		sudo curl\
          -L "https://github.com/docker/compose/releases/download/${_compose_version}/docker-compose-$(uname -s)-$(uname -m)"\
          -o /usr/local/bin/docker-compose &>/dev/null
		sudo chmod +x /usr/local/bin/docker-compose &>/dev/null
		sudo curl\
          -L https://raw.githubusercontent.com/docker/compose/${_compose_version}/contrib/completion/bash/docker-compose\
          -o /etc/bash_completion.d/docker-compose &>/dev/null

	fi

	if [[ $RUST =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RUST ]]; then
		printf '\nInstalling RUST... ' | "${WTL[@]}"

		if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete -y &>/dev/null; then
			if [ -e "${HOME}/.cargo/env" ]; then
				# shellcheck source=/dev/null
				source "${HOME}/.cargo/env"

				mkdir -p "${HOME}/.local/share/bash-completion/completions"
				touch "${HOME}/.local/share/bash-completion/completions/rustup"
				rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

				COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
				for COMPONENT in "${COMPONENTS[@]}"; do
					&>>/dev/null rustup component add "$COMPONENT"
				done

				[ -n "$(command -v code)" ] && code --install-extension rust-lang.rust &>/dev/null
			fi
			printf "successful\n" | "${WTL[@]}"
		else
			printf "unsuccessful\n" | "${WTL[@]}"
		fi
	fi
	
	printf '\n\n' | "${WTL[@]}"
	succ 'Finished with processing user-choices' "$LOG"
}

function post() {
	if [[ -z $(command -v shutdown) ]]; then
		warn 'Altough recommended, could not find shutdown to restart'
		return 1
	fi

	read -p "It is recommended to restart. Would you like to schedule a restart? [Y/n]" -r RESTART
	if [[ $RESTART =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RESTART ]]; then
	    shutdown --reboot 1 &>/dev/null
		inform 'Rebooting in one minute'
	fi
}

# ! Main

function main() {
    if ! sudo printf ''; then
		echo ''
		err 'User input invalid. Aborting.' | "${WTL[@]}"
		exit 1
	fi

	prechecks
	init

	warn 'Desktop packaging has begun' | "${WTL[@]}"

	choices
	check_lightdm

	add_ppas

	inform 'Initial update' "$LOG"
	script_update "$LOG"
	
	packages
	icons_and_colors
	process_choices

	succ 'Finished packaging stage' "$LOG"
	post
}

main "$@" || exit 1

