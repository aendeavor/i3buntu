#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a desktop installation.
# Via APT, core utils, browser, graphical environment
# and much more is being installed.
#
# current version - 0.9.0

sudo echo -e "\nPackaging stage has begun!"

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

## init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

## init of logfile
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG" ]]; then
        &>/dev/null sudo rm $LOG
    fi
    touch "$LOG"
fi
WTL=( tee -a "${LOG}" )

# ? Preconfig finished
# ? User-choices begin

echo -e "\nPlease make your choices:"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install Build-Essentials? [Y/n]" -r R2
read -p "Would you like to get RUST? [Y/n]" -r R3

# ? User choices end
# ? Init of package selection

CRITICAL=(
    ubuntu-drivers-common
    intel-microcode
    curl
    wget
    libaio1

    net-tools
    
    software-properties-common
    python3-distutils
    snapd

    vim
    neovim

    policykit-desktop-privileges
    policykit-1-gnome
    gnome-keyring*
    libgnome-keyring0
)

ENV=( )

MISC=(
    xsel
    xclip

    htop
)

PACKAGES=( "${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}" )

# ? End of init of package selection
# ? Actual script begins

echo -e "\nStarted at: $(date)\n\nInitial update" | ${WTL[@]}

sudo apt-get -y update | ${WTL[@]}
sudo apt-get -y upgrade | ${WTL[@]}

echo -e "Installing packages:\n" | ${WTL[@]}

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

for PACKAGE in "${PACKAGES[@]}"; do
    "${LOG}" ${AI[@]} ${PACKAGE} | ${WTL[@]}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}" | ${WTL[@]}
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}" | ${WTL[@]}
        printf "\n"
    fi
done

echo -e 'Post-Update via APT' | ${WTL[@]}
>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade

echo -e '\nFinished with the actual script.' | ${WTL[@]}

# ? Actual script finished
# ? Extra script begins

echo -e 'Processing user-choices:\n' | ${WTL[@]}

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo -e 'Enabling ubuntu-drivers autoinstall...' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    echo -e 'Installing build-essential & cmake...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e '\n\nInstalling RUST...' | ${WTL[@]}
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "${HOME}/.cargo/env"
    
    mkdir -p "${HOME}/.local/share/bash-completion/completions"
    touch "${HOME}/.local/share/bash-completion/completions/rustup"
    rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

    COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
    for COMPONENT in ${COMPONENTS[@]}; do
        rustup component add $COMPONENT | ${WTL[@]}
    done

    rustup update | ${WTL[@]}
fi


echo -e 'Finished with processing user-choices. One last update...' | ${WTL[@]}

>/dev/null 2>>"${LOG}" sudo apt-get -y update
>/dev/null 2>>"${LOG}" sudo apt-get -y upgrade
>/dev/null 2>>"${LOG}" sudo snap refresh

# ? Finish & Execution of next script

echo -e "\nPackaging has finished!\nEnded at: $(date)\n" | ${WTL[@]}
echo -e "\nStarting configuration." | ${WTL[@]}

${DIR}/_server_configuration.sh
