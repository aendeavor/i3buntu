#!/usr/bin/env bash

# This script serves as a wrapper for
# the installation of the icon theme
# "Tela".
# 
# current version - 0.0.1

# ? Preconfig

LOG="$1"
NAME="tela"

# ? Preconfig finished
# ? Actual script begins

echo -e 'Icon theme "Tela" will be installed...' >> "$LOG"

cd /tmp
rm -r Tela* tela* &>/dev/null

wget -O ${NAME}.zip "https://github.com/vinceliuice/Tela-icon-theme/archive/2019-09-29.zip" >> "$LOG"
unzip "${NAME}.zip" &> /dev/null
mv Tela* "${NAME}"

find "/tmp/tela/" -maxdepth 1 -regex "install.sh" -type f -exec chmod +x {} \;
/tmp/tela/install.sh -a >> "$LOG"

# ? Actual script finished
