#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a server installation.
# 
# current version - 0.9.3

sudo printf ""

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

RED='\033[0;31m'    # RED
GRE='\033[1;32m'    # GREEN
YEL='\033[1;33m'    # YELLOW
BLU='\033[1;34m'    # BLUE
NC='\033[0m'        # NO COLOR

ERR="${RED}ERROR${NC}\t"
WAR="${YEL}WARNING${NC}\t"
SUC="${GRE}SUCCESS${NC}\t"
INF="${BLU}INFO${NC}\t"

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

sudo echo -e "${INF}Packaging has begun!\n${INF}Please make your choices:\n"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install Build-Essentials? [Y/n]" -r R2
read -p "Would you like to install Docker? [Y/n]" -r R3

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e "\n${WAR}Docker has been chosen as an installation candidate. This may reqire manual user-input near the end of this script.\n"
fi

read -p "Would you like to get RUST? [Y/n]" -r R4

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    echo -e "\n${WAR}Rust has been chosen as an installation candidate. This reqires manual user-input at the end of this script.\n"
    sleep 3s
fi

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

echo -e "${INF}Started at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Initial update" | ${WTL[@]}

sudo apt-get -y update | ${WTL[@]}
sudo apt-get -y upgrade | ${WTL[@]}

echo -e "${INF}Installing packages\n" | ${WTL[@]}

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

echo -e "\n${SUC}Finished with actual script" | ${WTL[@]}


# ? Actual script finished
# ? Extra script begins

echo -e "${INF}Processing user-choices\n" | ${WTL[@]}

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo 'Enabling ubuntu-drivers autoinstall' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    echo 'Installing build-essential & CMake' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
fi

if [[ $RC3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC3 ]]; then
    echo -e 'Installing Docker' | ${WTL[@]}
    echo -e "${WAR}Manual user-input may be requiered!\n" | ${WTL[@]}
    $(readlink -m "${DIR}/../sys/docker/get_docker.sh") $DIR
fi

if [[ $R12 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R12 ]]; then
    echo -e "Installing RUST" | ${WTL[@]}
    echo -e "${WAR}Manual user-input requiered!\n" | ${WTL[@]}

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete
    
    source "${HOME}/.cargo/env"
    
    mkdir -p "${HOME}/.local/share/bash-completion/completions"
    touch "${HOME}/.local/share/bash-completion/completions/rustup"
    rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

    COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
    for COMPONENT in ${COMPONENTS[@]}; do
        &>>"${LOG}" rustup component add $COMPONENT
    done

    >/dev/null 2>>"${LOG}" rustup update
fi

echo -e "\n${SUC}Finished with processing user-choices" | ${WTL[@]}

# ? Extra script finished
# ? Execution of next script

echo -e "${INF}This script has finished!\n${INF}Ended at: $(date '+%d.%m.%Y-%H:%M')\n${INF}Starting configuration-script now" | ${WTL[@]}

"${DIR}/server_configuration.sh"
