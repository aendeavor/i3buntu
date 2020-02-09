#!/bin/bash

# This script serves as the main post-packaging
# script for server installations, i.e. it
# backups existing config files and deploys new
# and correct version from this repository.
# This sctipt is not executed by hand, but rather
# by the sever_packaging.sh script after it has
# run.
# 
# current version - 0.9.0 unstable

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

	HOME_FILES=( "${HOME}/.bash_aliases" "${HOME}/.bashrc" "${HOME}/.vimrc" )
	for FILE in ${HOME_FILES[@]}; do
	    if [[ -f "$FILE" ]]; then
	        backupFile="${BACK}${FILE#~}.bak"
	        echo -e "-> Found ${FILE}\n\tBacking up to ${backupFile}" | ${WTL[@]}
	        >/dev/null 2>>"${LOG}" sudo ${RS[@]} "$FILE" "$backupFile"
	    fi
	done

	if [[ -d "${HOME}/.vim" ]]; then
	    echo -e "-> Found ~/.vim directory!\n\tBacking up to ${BACK}/.vim" | ${WTL[@]}
	    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.vim" "${BACK}"
	    rm -rf "${HOME}/.vim"
	fi

	if [ -d "${HOME}/.config" ]; then
	    echo -e "-> Found ~/.config directory!\n\tBacking up to ${BACK}/.config" | ${WTL[@]}
	    >/dev/null 2>>"${LOG}" sudo ${RS[@]} "${HOME}/.config/i3" "${BACK}"
	fi
}

## deployment of configuration files
deploy() {
	inform "Proceeding to deploying config files" "$LOG"

	DEPLOY_IN_HOME=( sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo )
	for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
	    echo -e "-> Syncing $(basename -- "${sourceFile}")"  | ${WTL[@]}
	    >/dev/null 2>>"${LOG}" ${RS[@]} "${SYS}/${sourceFile}" "${HOME}"
	done
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
	sudo inform "Configuration has begun\n"

	init
	backup
	deploy

	succ 'Finished' "$LOG"
	post
}

main "$@" || exit 1
