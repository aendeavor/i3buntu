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
cd "${FONTDIR}/FiraCode"
for TYPE in Bold Light Medium Regular Retina; do
    FILE_URL="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${TYPE}.ttf?raw=true"

    wget -O "FiraCode-${TYPE}.ttf" "${FILE_URL}" -q --show-progress
done

# FiraCode Nerd fonts

NERDFONT="FiraCodeNerd"
MONOFONT="FiraMono"

cd "${FONTDIR}"

mkdir -p "${NERDFONT}"
mkdir -p "${MONOFONT}"

cd "${NERDFONT}"
wget -O "${NERDFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraCode.zip" -q --show-progress
&>/dev/null unzip -u "${NERDFONT}.zip"
&>/dev/null rm "${NERDFONT}.zip"

cd "../${MONOFONT}"
wget -O "${MONOFONT}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip" -q --show-progress
&>/dev/null unzip -u "${MONOFONT}.zip"
&>/dev/null rm "${MONOFONT}.zip"

# ? Actual script finished
