#!/usr/bin/env bash

FONTDIR="${HOME}/.local/share/fonts"
FONTNAME="FontAwesome"

if [[ ! -d "${FONTDIR}" ]]; then
    mkdir -p "${FONTDIR}"
fi

cd $FONTDIR
rm -rf $FONTNAME
rm -rf ${FONTNAME}.zip

wget -O ${FONTNAME}.zip "https://github.com/FortAwesome/Font-Awesome/releases/download/5.11.2/fontawesome-free-5.11.2-desktop.zip"

unzip ${FONTNAME}.zip
rm ${FONTNAME}.zip

mv "fontawesome-free-5.11.2-desktop" $FONTNAME
