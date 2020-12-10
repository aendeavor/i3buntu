#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a server installation.
# 
# current version - 1.5.0 stable

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages -qq)
AI=( sudo apt-get install "${IF[@]}" )
WTL=( tee -a "${LOG}" )

# shellcheck source=../sys/sh/.bash_aliases
. "${DIR}/../sys/sh/.bash_aliases"

# ? Init of package selection

CRITICAL=(
    ubuntu-drivers-common
    intel-microcode
    curl
    wget
    libaio1

    net-tools
    
    software-properties-common
    python3-distutils
    snapd

    vim
    git
)

ENV=(
    htop
    tmux
)

MISC=(
    xsel
    xclip

    neofetch

    ncdu
	ripgrep
    python3-dev
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
	        &>/dev/null sudo rm "$LOG"
	    fi
	    touch "$LOG"
	fi
}

function choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r UDA
	read -p "Would you like to install Build-Essentials? [Y/n]" -r BE
	read -p "Would you like to install NeoVIM? [Y/n]" -r NVIM

	DOCK="n"
	[ -z "$(command -v docker)" ] && read -p "Would you like to install Docker/Compose? [Y/n]" -r DOCK
	
	read -p "Would you like to install RUST? [Y/n]" -r RUST

	echo ''
}

function prechecks() {
	_programs=( apt dpkg apt-get )
	for _program in "${_programs[@]}"; do
		if [[ -z $(command -v "${_program}") ]]; then
			err "Could not find command ${_program}\n\t\tAborting."
			exit 100
		fi
	done
}

## (un-)install all packages with APT
function packages() {
    &>/dev/null sudo add-apt-repository -y ppa:git-core/ppa
	inform "Installing packages\n" "$LOG"

	printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
	printf "\n"

	for PACKAGE in "${PACKAGES[@]}"; do
		2>>"${LOG}" >>/dev/null "${AI[@]}" "${PACKAGE}"

		local EC=$?
		if (( EC != 0 )); then
			printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
		else
			printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
		fi

		printf "\n"
		echo -e "${PACKAGE} (${EC})" &>>"${LOG}"
	done

	echo "" | "${WTL[@]}"
	succ "Finished with packaging" "$LOG"
}

## processes user-choices from the beginning
function process_choices() {
	inform "Processing user-choices" "$LOG"

	if [[ $UDA =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $UDA ]]; then
		printf '\nEnabling ubuntu-drivers autoinstall... ' | "${WTL[@]}"
		test_on_success "$LOG" sudo ubuntu-drivers autoinstall
	fi

	if [[ $BE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $BE ]]; then
		printf '\nInstalling build-essential & CMake... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" build-essential cmake
	fi

	if [[ $NVIM =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $NVIM ]]; then
		printf '\nInstalling NeoVIM... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" neovim
	fi

	if [[ $DOCK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $DOCK ]]; then
		printf '\nInstalling Docker... ' | "${WTL[@]}"
		test_on_success "$LOG" "${AI[@]}" docker.io
        sudo systemctl enable --now docker >/dev/null 2>>"$LOG"
		sudo usermod -aG docker "$(whoami)" &>/dev/null

        local _compose_version="1.25.5"
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

		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete -y &>/dev/null
		
		local RSP=$?
		if [ $RSP -ne 0 ]; then
			printf "unsuccessful" | "${WTL[@]}"
		else
			if [[ -e "${HOME}/.cargo/env" ]]; then
				# shellcheck source=/dev/null
				source "${HOME}/.cargo/env"

				mkdir -p "${HOME}/.local/share/bash-completion/completions"
				touch "${HOME}/.local/share/bash-completion/completions/rustup"
				rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

				COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
				for COMPONENT in "${COMPONENTS[@]}"; do
					&>>/dev/null rustup component add "$COMPONENT"
				done

				if [ -n "$(command -v code)" ]; then
					code --install-extension rust-lang.rust &>/dev/null
				fi
			fi
			printf "successful." | "${WTL[@]}"
		fi
	fi

	printf "\n\n" | "${WTL[@]}"
	succ 'Finished with processing user-choices' "$LOG"
}

# execution of next script
function next() {
	succ 'Packaging stage finished'

	"${DIR}/server_configuration.sh"
}

function post() {
	if [[ -z $(command -v shutdown) ]]; then
		warn 'Altough recommended, could not find shutdown command to restart'
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

function main() {
    if ! sudo printf ''; then
		echo ''; err 'User input invalid. Aborting.'; exit 1
	fi
	
	prechecks
	init
	
	warn "Server packaging has begun" | "${WTL[@]}"

	choices

	inform 'Initial update' "$LOG"
	script_update "$LOG"
	
	packages
	process_choices

	next
	post
}

main "$@" || exit 1

