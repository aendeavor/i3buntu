#!/usr/bin/env bash

# Upgrades i3-gaps in-place to support rounded
# corners. Loads build-dependencies which are
# required ad-hoc.

# author    Georg Lauterbach
# version   0.2.1 unstable

trap "exit 1" ERR

dpkg -s i3-wm apt

if ! dpkg -s git
then
	sudo apt-get -y install git
fi

cd "$HOME" || exit 2
[[ ! -d i3-radius ]] &&	git clone https://github.com/terroo/i3-radius

cd i3-radius || exit 2

sudo apt-get -y build-dep i3-wm
grep -q -s "\-\-prefix=/usr/local" build.sh || sed -i\
	"s/--prefix=\/usr/--prefix=\/usr\/local/g" build.sh

sh build.sh
