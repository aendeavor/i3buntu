#!/usr/bin/env bash

# Serves a wrapper for installing i3-gaps
# from source
# 
# version   0.1.0
# sources   https://gist.github.com/dabroder/813a941218bdb164fb4c178d464d5c23

# ? Preconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

AI=( sudo apt-get install -y -qq )

# initiate aliases and functions
. "${DIR}/../sh/.bash_aliases"

# initiate all the needed dependencies
DEPS=(
    libxcb1-dev
    libxcb-keysyms1-dev
    libxcb-util0-dev
    libxcb-icccm4-dev
    libxcb-randr0-dev
    libxcb-cursor-dev
    libxcb-xinerama0-dev
    libxcb-xkb-dev
    libxcb-xrm0
    libxcb-xrm-dev
    libxcb-shape0-dev

    libxkbcommon-dev
    libxkbcommon-x11-dev
    
    libpango1.0-dev
    libyajl-dev
    libstartup-notification0-dev
    libev-dev
    
    autoconf
    automake
)

# ? End of init of package selection
# ? Actual script begins

for PACKAGE in "${DEPS[@]}"; do
    &>>/dev/null ${AI[@]} ${PACKAGE}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
    fi
    
    printf "\n"
done

cd /tmp

# clone the repository
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps

# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/

# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr/local --sysconfdir=/etc --disable-sanitizers

make
sudo make install
