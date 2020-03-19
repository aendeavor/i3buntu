#!/bin/bash

# This script serves as the main post-packaging
# script for server installations, i.e. it
# backups existing config files and deploys new
# and correct version from this repository.
# This sctipt is not executed by hand, but rather
# by the sever_packaging.sh script after it has
# run.
# 
# current version - 0.9.05 unstable

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$( readlink -m "${DIR}/../../backups/configuration/$( date '+%d-%m-%Y--%H-%M-%S' )" )"
RES="$( readlink -m "${DIR}/../" )"
SYS="$( readlink -m "${RES}/sys")"
LOG="${BACK}/configuration_log"

RS=( rsync -ahq --delete )
WTL=( tee -a "$LOG" )

## initiate aliases and functions
. "${SYS}/sh/.bash_aliases"

# ? Actual script

## init of backup-directory and logfile
init() {
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

## backup of configuration files
backup() {
	inform "Checkig for existing files\n" "$LOG"

	_home_files=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" )
	for _file in ${_home_files[@]}; do
	    if [[ -f "$_file" ]]; then
	        backupFile="${BACK}${_file#~}.bak"
	        echo -e "-> Found ${_file}... backing up" | ${WTL[@]}
			# echo -e "\tBacking up to ${backupFile}"
	        >/dev/null 2>>"${LOG}" sudo ${RS[@]} "$_file" "$backupFile"
	    fi
	done

	if [[ -d "${HOME}/.vim" ]]; then
	    echo -e "-> Found ~/.vim directory... backing up" | ${WTL[@]}
		# echo -e "\tBacking up to ${BACK}/.vim"
	    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.vim" "${BACK}"
	    rm -rf "${HOME}/.vim"
	fi

	if [ -d "${HOME}/.config" ]; then
	    echo -e "-> Found ~/.config directory... backing up" | ${WTL[@]}
		# echo -e "\tBacking up to ${BACK}/.config"
	    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.config/i3" "${BACK}"
	fi
}

## deployment of configuration files
deploy() {
	echo ''
	inform "Proceeding to deploying config files\n" "$LOG"

	DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc )
	for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
	    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
	    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
	done

	>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/sh/.bashrc" "/root"
	>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/sh/.bash_aliases" "/root"

	mkdir -p "${HOME}/.config/nvim"
	sudo mkdir -p "/root/.config/nvim"

	if dpkg -s neovim &>/dev/null; then
		echo -e "-> Syncing NeoVIM's configuration"
		>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/.vimrc" "${HOME}"
		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/vi/.vimrc" "/root"

		>/dev/null 2>>"${LOG}" sudo ${RS[@]} "${SYS}/vi/init.vim" "/root/.config/nvim"
		>/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/vi/init.vim" "${HOME}/.config/nvim"

    	>/dev/null 2>>"${LOG}" curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
    	>/dev/null 2>>"${LOG}" curl -fLo '/root/.local/share/nvim/site/autoload/plug.vim' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
	fi

    echo -e "-> Copying PowerLine-Go to /bin\n"
    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/sh/powerline-go-linux-amd64" "/bin"
}

# ! Main

main() {
    sudo printf ''
	inform "Configuration has begun"

	init
	backup
	deploy

    succ "Configuration stage finished\n"
}

main "$@" || exit 1
