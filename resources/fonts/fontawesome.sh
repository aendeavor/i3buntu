#!/usr/bin/env bash

# ? Preconfig

FONTDIR="${HOME}/.local/share/fonts"
FONTNAME="FontAwesome"

if [[ ! -d "${FONTDIR}" ]]; then
    mkdir -p "${FONTDIR}"
fi

# ? Preconfig finished
# ? Actual script begins

cd $FONTDIR
&>/dev/null rm -rf $FONTNAME
&>/dev/null rm -rf ${FONTNAME}.zip

wget -O ${FONTNAME}.zip "https://github.com/FortAwesome/Font-Awesome/releases/download/5.11.2/fontawesome-free-5.11.2-desktop.zip" -q --show-progress

&>/dev/null unzip ${FONTNAME}.zip
&>/dev/null rm ${FONTNAME}.zip

&>/dev/null mv "fontawesome-free-5.11.2-desktop" $FONTNAME

# ? Actual script finished
