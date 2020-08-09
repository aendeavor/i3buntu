#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.1.2 unstable

function main() {
	local _release="v2.0.0-stable"
	if [[ -e "${_release}.zip" ]]; then
		printf "There is already a file named '%s.zip' in this directory. Aborting.\n" "${_release}"
		exit 10
	fi

	if ! wget "https://github.com/aendeavor/i3buntu/archive/${_release}.tar.gz" &>/dev/null
	then
		printf 'Could not download repository. WGET exit code was %s. Aborting.\n' "$?"
		exit 100
	fi

	unzip -u "${_release}.zip" &>/dev/null
	cd "apollo-${_release}" || exit 200
	make install < /dev/tty
}

main || exit 1
