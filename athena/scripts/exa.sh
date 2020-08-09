#!/usr/bin/env bash

# Installs EXA with Cargo to replace ls.

# author		Georg Lauterbach
# version		0.2.0 unstable

if [[ -n $(command -v cargo) ]]
then
	echo "Cargo not installed. Aborting."
	exit 1
fi

cargo install exa || exit 2

if [[ -e "${HOME}/.bash_aliases" ]]
then
	sed -i "s/alias ls='ls -lh --color\
		=auto'/alias ls='exa --binary --\
		header --long --group --git'/g"\
		"${HOME}/.bash_aliases"
	sed -i "s/alias lsa='ls -lhA --color\
		=auto'/alias lsa='exa -b -h -l -g \
		--git -a'/g"\
		"${HOME}/.bash_aliases"
fi
