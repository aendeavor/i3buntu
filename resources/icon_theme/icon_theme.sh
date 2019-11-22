#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of the icon theme
# "Tela".
# 
# current version - 0.2.4

# ? Preconfig

LOG="$1"
NAME="tela"
DIR="${HOME}/icon_tmp"

# ? Preconfig finished
# ? Actual script begins

echo -e 'Icon theme "Tela" will be installed...' >> "$LOG"

&>/dev/null rm -r "${DIR}"
mkdir -p "${DIR}"
cd "${DIR}"

wget -O ${NAME}.zip "https://github.com/vinceliuice/Tela-icon-theme/archive/2019-09-29.zip" >> "$LOG"
unzip "${NAME}.zip" &> /dev/null
mv Tela* "${NAME}"

find "${DIR}/${NAME}" -maxdepth 1 -regex "install.sh" -type f -exec chmod +x {} \;
cd "${DIR}/${NAME}"
./install.sh -a >> "$LOG"

rm -r "${DIR}"

# ? Actual script finished
