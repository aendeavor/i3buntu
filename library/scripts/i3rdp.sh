#!/usr/bin/env bash

# Downloads Picom, Dunst and i3-radius
# via `git clone` and installs them.
# Dependencies should have already been
# installed by i3buntu.
#
# author   Georg Lauterbach
# version  0.2.0 unstable

set -euEo pipefail
trap '_log_err ${_} ${LINENO} ${?}' ERR

function _log_err()
{
  echo -e "ERROR occured :: source ${1} ; line ${2} ; exit code ${3}"
  unset GH
}

GH='https://github.com'

function _install_picom()
{
	cd /tmp && git clone "${GH}/yshui/picom.git"
	cd picom

	git submodule update --init --recursive
	meson --buildtype=release . build
	ninja -C build

	sudo ninja -C build install
}

function _install_dunst()
{
	cd /tmp && git clone "${GH}/dunst-project/dunst.git"
	cd dunst

	make
	sudo make install
}

function _install_i3-radius()
{
	cd /tmp && git clone "${GH}/terroo/i3-radius.git"
	cd i3-radius

	./build.sh
}

function _main()
{
	sudo apt-get -y remove dunst compton
	
  _install_i3-radius
  _install_dunst
  _install_picom

  unset GH
}

_main
