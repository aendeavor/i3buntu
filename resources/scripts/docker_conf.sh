#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# current version - 0.9.0

echo -e "\nPackaging stage has begun!"

# ? Preconfig

## directories and files - absolute & normalized
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SYS="$(readlink -m "${DIR}/../sys")"

RS=( rsync -ahq --delete )

IF=(--yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages)
AI=(apt-get install ${IF[@]})
SI=(snap install)

# ? Preconfig finished
# ? User-choices begin

echo -e "\nPlease make your choices:"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install Build-Essentials? [Y/n]" -r R2
read -p "Would you like to get RUST? [Y/n]" -r R3

# ? User choices end
# ? Init of package selection

CRITICAL=(
    curl
    wget
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
    \
    htop
)

PACKAGES=("${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}")

# ? End of init of package selection
# ? Actual script begins

echo -e "\nStarted at: $(date)\n\nInitial update"

apt-get -y update
apt-get -y upgrade

echo -e "Installing packages:\n"

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

for PACKAGE in "${PACKAGES[@]}"; do
    ${AI[@]} ${PACKAGE}

    EC=$?
    if (($EC != 0)); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
        printf "\n"
    fi
done

echo -e 'Post-Update via APT'
apt-get -y update
apt-get -y upgrade

DEPLOY_IN_HOME=(sh/.bashrc sh/.bash_aliases vi/.vimrc vi/.viminfo)
for sourceFile in "${DEPLOY_IN_HOME[@]}"; do
    echo -e "-> Syncing $(basename -- "${sourceFile}")"
    ${RS[@]} &>>/dev/null "${SYS}/${sourceFile}" "${HOME}"
done

# ? Actual script finished

echo -e "\nPackaging has finished!\nEnded at: $(date)\n"

# ? Execution of next script

echo -e "\nStarting configuration."
${DIR}/_docker_configuration.sh
