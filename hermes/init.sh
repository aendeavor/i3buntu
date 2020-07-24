#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.1.0 unstable

function main() {
	local _branch=development
	if [[ -e "${_branch}.zip" ]]; then
		printf "There is already a file named '%s.zip' in this directory. Aborting.\n" "${_branch}"
		exit 10
	fi

	if ! wget "https://github.com/aendeavor/apollo/archive/${_branch}.zip" &>/dev/null
	then
		printf 'Could not download repository. WGET exit code was %s. Aborting.\n' "$?"
		exit 100
	fi

	unzip -u "${_branch}.zip" &>/dev/null
	cd "apollo-${_branch}" || exit 200
	make install < /dev/tty
}

main || exit 1
