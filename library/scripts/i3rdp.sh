#! /usr/bin/env bash

: '
# ? version       0.2.0 RC1 BETA1 UNSTABLE
# ? executed      manually
# ? task          downloads Picom, Dunst and i3-radius
# ?               via git clone and installs them
# ? note          Dependencies should have already been
# ?               installed by i3buntu
'

# shellcheck source=../../scripts/lib/errors.sh
. ../../scripts/lib/errors.sh

GH='https://github.com'
trap 'unset GH' EXIT

function install_picom()
(
  cd /tmp
  git clone "${GH}/yshui/picom.git"
  cd picom

  git submodule update --init --recursive
  meson --buildtype=release . build
  ninja -C build

  sudo ninja -C build install
)

function install_dunst()
(
  cd /tmp
  git clone "${GH}/dunst-project/dunst.git"

  cd dunst

  make
  sudo make install
)

function install_i3-radius()
(
  cd /tmp
  git clone "${GH}/terroo/i3-radius.git"
  cd i3-radius

  ./build.sh
)

sudo apt-get -y remove dunst compton
  
install_i3-radius
install_dunst
install_picom
