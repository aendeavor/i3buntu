#!/bin/bash

# This script serves as the main post-packaging
# script for server installations, i.e. it
# backups existing config files and deploys new
# and correct version from this repository.
# This sctipt is not executed by hand, but rather
# by the sever_packaging.sh script.
# 
# current version - 1.0.0 unstable

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../../backups/configuration/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/configuration_log"

RS=( rsync -ahq --delete )
WTL=( tee -a "$LOG" )

# shellcheck source=../sys/sh/.bash_aliases
. "${SYS}/sh/.bash_aliases"

# ? Actual script

## init of backup-directory and logfile
init() {
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

## backup of configuration files
function backup() {
	inform "Checkig for existing files\n" "$LOG"

	_home_files=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" )
	for _file in "${_home_files[@]}"; do
	    if [[ -f "$_file" ]]; then
	        backupFile="${BACK}${_file#~}.bak"
	        echo -e "-> Found ${_file}... backing up" | "${WTL[@]}"
			# echo -e "\tBacking up to ${backupFile}"
	        >/dev/null 2>>"${LOG}" sudo "${RS[@]}" "$_file" "$backupFile"
	    fi
	done

	if [[ -d "${HOME}/.vim" ]]; then
	    echo -e "-> Found ~/.vim directory... backing up" | "${WTL[@]}"
		# echo -e "\tBacking up to ${BACK}/.vim"
	    >/dev/null 2>>"${LOG}" sudo "${RS[@]}" "${HOME}/.vim" "${BACK}"
	    rm -rf "${HOME}/.vim"
	fi

	if [ -d "${HOME}/.config" ]; then
	    echo -e "-> Found ${HOME}/.config directory... backing up" | "${WTL[@]}"
		# echo -e "\tBacking up to ${BACK}/.config"
	    >/dev/null 2>>"${LOG}" sudo "${RS[@]}" "${HOME}/.config/i3" "${BACK}"
	fi
}

## deployment of configuration files
function deploy() {
	echo ''
	inform "Proceeding to deploying config files\n" "$LOG"

    echo -e "-> Copying PowerLine-Go to /bin"
    >/dev/null 2>>"${LOG}" "${RS[@]}" "${SYS}/sh/powerline-go-linux-amd64" "/bin"

	local _deploy_in_home=( sh/.bashrc sh/.bash_aliases vi/.vimrc )
	for sourceFile in "${_deploy_in_home[@]}"; do
	    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | "${WTL[@]}"
	    >/dev/null 2>>"${LOG}" "${RS[@]}" "${SYS}/${sourceFile}" "${HOME}"
	done

	{ sudo "${RS[@]}" "${SYS}/sh/.bashrc" "/root"; sudo "${RS[@]}" "${SYS}/sh/.bash_aliases" "/root"; } >/dev/null 2>>"${LOG}"

	if dpkg -s neovim &>/dev/null; then
		mkdir -p "${HOME}/.config/nvim"
		sudo mkdir -p "/root/.config/nvim"
		echo -e "-> Syncing NeoVIM's configuration"

		{
			"${RS[@]}" "${SYS}/vi/.vimrc" "${HOME}"
			sudo "${RS[@]}" "${SYS}/vi/.vimrc" "/root"
			
			sudo "${RS[@]}" "${SYS}/vi/init.vim" "/root/.config/nvim"
			"${RS[@]}" "${SYS}/vi/init.vim" "${HOME}/.config/nvim"
    		
			curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    		curl -fLo '/root/.local/share/nvim/site/autoload/plug.vim' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		} >/dev/null 2>>"${LOG}"

		echo ''
		warn "You will need to run :PlugInstall seperately in NeoVIM\n\t\t\t\t\tas you cannot execute this command in a shell.\n\t\t\t\t\tThereafter, run python3 ~/.config/nvim/plugged/YouCompleteMe/install.py"
	fi
}

# ! Main

main() {
    sudo printf ''
	inform "Server configuration has begun"

	init
	backup
	deploy

    succ "Configuration stage finished\n"
}

main "$@" || exit 1

