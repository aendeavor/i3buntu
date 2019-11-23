#!/usr/bin/env bash

# ? Preconfig

FONTDIR="${HOME}/.local/share/fonts"
FONTNAME="RobotoMonoNerd"

# ? Preconfig finished
# ? Actual script begins

cd "${FONTDIR}"

mkdir -p "${FONTNAME}"
cd "${FONTNAME}"
wget -O "${FONTNAME}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/RobotoMono.zip" -q --show-progress
&>/dev/null unzip -u "${FONTNAME}.zip"
&>/dev/null rm "${FONTNAME}.zip"

# ? Actual script finished
