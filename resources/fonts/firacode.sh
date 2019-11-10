#!/usr/bin/env bash

# ? Preconfig

FONTDIR="${HOME}/.local/share/fonts"

if [[ ! -d "${FONTDIR}" ]]; then
    mkdir -p "${FONTDIR}"
fi

if [[ ! -d "${FONTDIR}/FiraCode" ]]; then
    mkdir -p "${FONTDIR}/FiraCode"
fi

# ? Preconfig finished
# ? Actual script begins

# FiraCode font
for type in Bold Light Medium Regular Retina; do
    file_path="${HOME}/.local/share/fonts/FiraCode/FiraCode-${type}.ttf"
    file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"

    wget -O "${file_path}" "${file_url}"
done

# FiraCode Nerd fonts

NERDFONT="FiraCodeNerd"
MONOFONT="FiraMono"

cd "${FONTDIR}"

mkdir -p "${NERDFONT}"
mkdir -p "${MONOFONT}"

cd "${NERDFONT}"
wget -O "${NERDFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip"
unzip "${NERDFONT}.zip"
rm "${NERDFONT}.zip"

cd "../${MONOFONT}"
wget -O "${MONOFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip"
unzip "${MONOFONT}.zip"
rm "${MONOFONT}.zip"

# ? Actual script finished
