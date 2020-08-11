#!/bin/bash

# Downloads APOLLO and starts installation.

# author	Georg Lauterbach
# version	0.2.0 stable

set -eE
trap 'echo "  :: ERROR" ; exit 200' ERR
trap 'echo "  :: INTERRUPT" ; exit 220' SIGINT
trap 'echo "  :: TERMINATION" ; exit 230' SIGTERM

function main() {
	local _release="2.0.0-stable"
	local _archive="v${_release}.tar.gz"

	if [[ -e "${_archive}" ]] || [[ -d "i3buntu-${_release}" ]]
	then
		printf '%s %s %s %s %s\n'\
			'There is already a file named'\
			"${_archive}"\
			"or a directory called"\
			"${_release}"\
			'in this directory. Aborting.'
		exit 10
	fi

	local _gh='https://github.com/'
	local _user="${_gh}aendeavor/i3buntu/archive"

	if ! wget "${_user}/${_archive}" &>/dev/null
	then
		printf '%s %s\n'\
			'Could not download repository.'\
			'Aborting.'
		exit 100
	fi

	tar -xzf "${_archive}" &>/dev/null
	cd "i3buntu-${_release}" || exit 200

	./apollo < /dev/tty
}

main || exit 1
