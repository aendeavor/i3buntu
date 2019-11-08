#!/usr/bin/env bash

FONTDIR="${HOME}/.local/share/fonts"
FONTNAME="IosevkaNerd"

cd "${FONTDIR}"

mkdir -p "${FONTNAME}"
cd "${FONTNAME}"
wget -O "${FONTNAME}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip"
unzip "${FONTNAME}.zip"
rm "${FONTNAME}.zip"
