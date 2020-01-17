#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages for a server installation.
# 
# current version - 1.0.0 stable

sudo printf ""

# ? Preconfig

## directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../../backups/packaging/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
SI=( sudo snap install )

# initiate aliases and functions
. "${DIR}/../sys/sh/.bash_aliases"

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

inform 'Packaging has begun'
inform "Please make your choices:\n"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install Build-Essentials? [Y/n]" -r R2
read -p "Would you like to install NeoVIM? [Y/n]" -r R3
read -p "Would you like to install Docker? [Y/n]" -r R4

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    warn 'Docker has been chosen as an installation candidate. This may reqire manual user-input near the end of this script.'
    sleep 1s
fi

read -p "Would you like to get RUST? [Y/n]" -r R5

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    warn 'Rust has been chosen as an installation candidate. This reqires manual user-input at the end of this script.'
    sleep 1s
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
    ranger

    policykit-desktop-privileges
    policykit-1-gnome
    gnome-keyring*
    libgnome-keyring0
)

ENV=(
    htop
)

MISC=(
    xsel
    xclip

    neofetch

    ncdu
)

PACKAGES=( "${CRITICAL[@]}" "${ENV[@]}" "${MISC[@]}" )

# ? End of init of package selection
# ? Actual script begins

echo ""
inform "Initial update" "$LOG"
update

inform "Installing packages\n" "$LOG"

printf "%-35s | %-15s | %-15s" "PACKAGE" "STATUS" "EXIT CODE"
printf "\n"

for PACKAGE in "${PACKAGES[@]}"; do
    2>>"${LOG}" >>/dev/null ${AI[@]} ${PACKAGE}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Not Installed" "${EC}"
    else
        printf "%-35s | %-15s | %-15s" "${PACKAGE}" "Installed" "${EC}"
    fi

    printf "\n"
    &>>"${LOG}" echo -e "${PACKAGE}\n\t -> EXIT CODE: ${EC}"
done

echo ""
succ "Finished with actual script" "$LOG"

# ? Actual script finished
# ? Extra script begins

inform "Processing user-choices\n" "$LOG"

## graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo 'Enabling ubuntu-drivers autoinstall' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    echo 'Installing build-essential & CMake' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" ${AI[@]} build-essential cmake
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e 'Installing NeoVIM...' | ${WTL[@]}
    >/dev/null 2>>"${LOG}" sudo apt-get install neovim
    >/dev/null 2>>"${LOG}" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    warn 'You will need to run :PlugInstall seperately in NeoVIM as you cannot execute this command in a shell.'
    warn 'Thereafter, run ~/.config/nvim/plugged/YouCompleteMe/install.py --racer-completer --tern-completer.'
    sleep 3s
fi

if [[ $RC4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC4 ]]; then
    echo -e 'Installing Docker' | ${WTL[@]}
    warn "Manual user-input may be requiered!\n" "$LOG"
    SH=$(readlink -m "${DIR}/../sys/docker/get_docker.sh")
    printf "\n"
    $SH "$LOG"
fi

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    echo -e "Installing RUST" | ${WTL[@]}
    warn "Manual user-input requiered!\n" "$LOG"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete
    
    if [[ -e "${HOME}/.cargo/env" ]]; then
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
fi

succ 'Finished with processing user-choices' "$LOG"

# ? Extra script finished
# ? Execution of next script

inform 'This script has finished'
inform 'Starting configuration-script now'

"${DIR}/server_configuration.sh"
