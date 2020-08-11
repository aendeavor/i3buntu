#!/usr/bin/env bash

# Downloads Picom, Dunst and i3-radius
# via `git clone` and installs them.
# Dependencies should have already been
# installed by APOLLO.
#
# author	Georg Lauterbach
# version	0.1.0 unstable

set -eE
trap 'echo "ERROR" ; exit 1' ERR

GH="https://github.com"

function p()
{
	cd /tmp || exit 1
	git clone ${GH}/yshui/picom.git
	cd picom || exit 1

	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build

	sudo ninja -C build install
}

function d()
{
	cd /tmp || exit 1
	git clone ${GH}/dunst-project/dunst.git
	cd dunst || exit 1

	make
	sudo make install
}

function i3r()
{
	git clone ${GH}/terroo/i3-radius.git
	cd i3-radius || exit 1

	./build.sh
}

function main()
{
	i3r ; d ; p
}

main || exit 1
unset GH
