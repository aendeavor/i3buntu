#!/usr/bin/env bash

FONTDIR="${HOME}/.local/share/fonts"

if [[ ! -d "${FONTDIR}" ]]; then
    mkdir -p "${FONTDIR}"
fi

# ? FiraCode font

for type in Bold Light Medium Regular Retina; do
    file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
    file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
    if [[ ! -e "${file_path}" ]]; then
        wget -O "${file_path}" "${file_url}"
    fi;
done

# ? FiraCode Nerd fonts

cd $FONTDIR

NERDFONT="FiraCodeNerd"
MONOFONT="FiraMono"

wget -O ${NERDFONT}.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip"
unzip ${NERDFONT}.zip

wget -O ${MONOFONT}.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip"
unzip ${MONOFONT}.zip

rm ${NERDFONT}.zip
rm ${NERDFONT}.zip
