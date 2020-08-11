#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.1.5 unstable

set -eE
trap 'echo "ERROR" ; exit 200' ERR
trap 'echo "INTERRUPT" ; exit 220' SIGINT SIGTERM

function main() {
	local _release="v2.0.0-stable"
	local _archive="${_release}.tar.gz"

	if [[ -e "${_archive}" ]]; then
		printf "There is already a file named '%s' in this directory. Aborting.\n" "${_archive}"
		exit 10
	fi

	if ! wget "https://github.com/aendeavor/i3buntu/archive/${_archive}" &>/dev/null
	then
		printf 'Could not download repository. WGET exit code was %s. Aborting.\n' "$?"
		exit 100
	fi

	tar -xzf "${_archive}" &>/dev/null
	cd "i3buntu-${_release}" || exit 200

	# shellcheck disable=SC2024
	sudo -E ./apollo < /dev/tty
}

main "$@" || exit 1
