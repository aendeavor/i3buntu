#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a server installation.
# 
# current version - 1.4.1 unstable

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )
WTL=( tee -a "${LOG}" )

# initiate aliases and functions
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
    ranger
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

## user-choices
function choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r UDA
	read -p "Would you like to install Build-Essentials? [Y/n]" -r BE
	read -p "Would you like to install NeoVIM? [Y/n]" -r NVIM
	read -p "Would you like to install Docker? [Y/n]" -r DOCK
	read -p "Would you like to install RUST? [Y/n]" -r RUST
}

function prechecks() {
	_programs=( apt dpkg apt-get )
	for _program in "${_programs[@]}"; do
		if [[ -z $(which "${_program}") ]]; then
			err "Could not find command ${_program}\n\t\t\t\t\t\t\tAborting"
			exit 100
		fi
	done
}

## (un-)install all packages with APT
function packages() {
	inform "Installing packages\n" "$LOG"

	printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
	printf "\n"

	for PACKAGE in "${PACKAGES[@]}"; do
		2>>"${LOG}" >>/dev/null ${AI[@]} ${PACKAGE}

		EC=$?
		if (( $EC != 0 )); then
			printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
		else
			printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
		fi

		printf "\n"
		&>>"${LOG}" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
	done

	echo ""
}

## processes user-choices from the beginning
function process_choices() {
	inform "Processing user-choices\n" "$LOG"

	## graphics driver
	if [[ $UDA =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $UDA ]]; then
		printf 'Enabling ubuntu-drivers autoinstall... ' | ${WTL[@]}
		test_on_success sudo ubuntu-drivers autoinstall "2>>${LOG}"
	fi

	if [[ $BE =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $BE ]]; then
		printf 'Installing build-essential & CMake... ' | ${WTL[@]}
		test_on_success ${AI[@]} build-essential cmake "2>>${LOG}"
	fi

	if [[ $NVIM =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $NVIM ]]; then
		printf 'Installing NeoVIM... ' | ${WTL[@]}
		test_on_success ${AI[@]} neovim "2>>${LOG}"

		printf 'Installing VimPlug for NeoVIM... '
		test_on_success curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim "2>>${LOG}"

		echo ''
  		warn 'You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell'
    	warn "Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py\n"
	fi

	if [[ $DOCK =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $DOCK ]]; then
		printf 'Installing Docker... ' | ${WTL[@]}
		test_on_success ${AI[@]} docker.io "2>>${LOG}"
	fi

	if [[ $RUST =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RUST ]]; then
		printf "Installing RUST" | ${WTL[@]}

		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete -y &>/dev/null
		
		if [[ $? -ne 0 ]]; then
			printf "unsuccessfull.\n"
		else
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

				>/dev/null "2>>${LOG}" rustup update
			fi
			printf "successfull.\n"
		fi
	fi
}

# ? Execution of next script

function next() {
	inform 'Packaging stage finished'
	inform 'Starting configuration stage'

	"${DIR}/server_configuration.sh"
}

# ! Main

function main() {
    sudo printf ''
	inform 'Packaging has begun'
	init
	choices

	echo ''
	prechecks

	inform 'Initial update' "$LOG"
	update &>>${LOG}
	
	packages
	succ "Finished with packaging" "$LOG"

	process_choices
	succ 'Finished with processing user-choices' "$LOG"

	next
}

main "$@" || exit 1
