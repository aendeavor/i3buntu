#!/usr/bin/env bash

# ? current version: FontAwesome Free 5.11.2 Desktop

FONTDIR="${HOME}/.local/share/fonts"
FONTNAME="RobotoMonoNerd"

cd "${FONTDIR}"

mkdir -p "${FONTNAME}"
cd "${FONTNAME}"
wget -O "${FONTNAME}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/RobotoMono.zip"
unzip "${FONTNAME}.zip"
rm "${FONTNAME}.zip"
