#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.1.3 unstable

function main() {
	local _release="v2.0.0-stable.tar.gz"
	if [[ -e "${_release}" ]]; then
		printf "There is already a file named '%s' in this directory. Aborting.\n" "${_release}"
		exit 10
	fi

	if ! wget "https://github.com/aendeavor/i3buntu/archive/${_release}" &>/dev/null
	then
		printf 'Could not download repository. WGET exit code was %s. Aborting.\n' "$?"
		exit 100
	fi

	tar -xzf "${_release}" &>/dev/null
	cd "i3buntu-${_release}" || exit 200
	make install < /dev/tty
}

main || exit 1
