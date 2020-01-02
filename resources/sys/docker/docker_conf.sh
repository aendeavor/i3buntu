#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# current version - 0.9.0

echo -e "\nDocker packaging and configuration has begun!"

# ? Preconfig

## directories and files - absolute & normalized
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SYS="$(readlink -m "${DIR}/sys")"

RS=( rsync -ahq --delete )

IF=(--yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
AI=(apt-get install ${IF[@]})

# ? Preconfig finished
# ? Init of package selection

CRITICAL=(
    curl
    wget
    rsync
    libaio1
    
    net-tools
    
    vim
    neovim
)

ENV=(
    build-essential
    cmake
)

MISC=(
    xsel
    xclip
    
    htop
)

PACKAGES=("${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}")

# ? End of init of package selection
# ? Actual script begins

echo -e "${INF}Started at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Initial update"

&>>/dev/null apt-get -y update
&>>/dev/null apt-get -y upgrade

echo -e "${INF}Installing packages:\n"

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

for PACKAGE in "${PACKAGES[@]}"; do
    &>>/dev/null ${AI[@]} ${PACKAGE}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
        printf "\n"
    fi
done

DEPLOY_IN_HOME=(sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo)
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "-> Syncing $(basename -- "${sourceFile}")"
    ${RS[@]} >>/dev/null "${SYS}/${sourceFile}" "/root"
done

# ? Actual script finished

echo -e "\nFinished!"
