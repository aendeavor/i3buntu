#!/bin/bash

# This script serves as the main installation script
# for all neccessary packages. Via APT, core utils,
# browser, graphical environment and much more is
# being installed.
#
# current version - 0.5.1

sudo echo -e "\nInstallation has begun!"

# ? Preconfig

## Directories and files - absolute & normalized
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BACK="$(readlink -m "${DIR}/../backups/packageInstallation/$(date '+%d-%m-%Y--%H-%M-%S')")"
LOG="${BACK}/packaging_log"

IF=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( &>>"${LOG}" sudo apt-get install ${IF[@]} )
SI=( &>>"${LOG}" sudo snap install )

## Init of backup-directory
if [[ ! -d "$BACK" ]]; then
    mkdir -p "$BACK"
fi

## Init of logfile
if [[ ! -f "$LOG" ]]; then
    if [[ ! -w "$LOG" ]]; then
        sudo rm $LOG &>/dev/null
    fi
    touch "$LOG"
fi
WTL=( tee -a "${LOG}" )

sudo apt-get -qq -y update
sudo apt-get -qq -y upgrade

# ? Preconfig finished
# ? User-choices begin

echo -e "Please make your choices: \n"

read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r R1
read -p "Would you like to install OpenJDK? [Y/n]" -r R2
read -p "Would you like to install Cryptomator? [Y/n]" -r R3
read -p "Would you like to install Balena Etcher? [Y/n]" -r R4
read -p "Would you like to install TeX? [Y/n]" -r R5
read -p "Would you like to install ownCloud? [Y/n]" -r R6
read -p "Would you like to install Build-Essentials? [Y/n]" -r R7
read -p "Would you like to get RUST? [Y/n]" -r R8
read -p "Would you like to install VS Code? [Y/n]" -r R9

RC1="no"
if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    read -p "Would you like to install recommended VS Code extensions?" -r RC1
fi

read -p "Would you like to install the JetBrains IDE suite? [Y/n]" -r R10

# ? User choices end
# ? Init of package selection

CRITICAL=( ubuntu-drivers-common htop intel-microcode curl wget )

PACKAGING=( software-properties-common python-software-properties snapd )

DISPLAY=( xorg xserver-xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings i3 )

GRAPHICS=( compton xbacklight feh rofi arandr mesa-utils mesa-utils-extra i3lock )

AUDIO=( pulseaudio gstreamer1.0-pulseaudio pulseaudio-module-raop pulseaudio-module-bluetooth )

FILES=( nemo file-roller p7zip-full filezilla )

SHELL=( rxvt-unicode vim xsel xclip neofetch )

AUTH=( policykit-desktop-privileges policykit-1-gnome gnome-keyring* libgnome-keyring0 )

THEMING=( gtk2-engines-pixbuf gtk2-engines-murrine lxappearance )

MISCELLANEOUS=( gparted fontconfig evince gedit nomacs python3-distutils scrot )

PACKAGE_SELECTION_ONE=( "${CRITICAL[@]}" "${PACKAGING[@]}" "${DISPLAY[@]}" "${GRAPHICS[@]}" )
PACKAGE_SELECTION_TWO=( "${AUDIO[@]}" "${FILES[@]}" "${SHELL[@]}" "${AUTH[@]}" "${THEMING[@]}" "${MISCELLANEOUS[@]}" )

# ? End of init of package selection
# ? Actual script begins

echo -e "Started at: $(date)" | ${WTL[@]}
echo -e 'Installing packages...'  | ${WTL[@]}

echo -e "\nFirst selection of packages...\n" | ${WTL[@]}
for PACKAGE in "${PACKAGE_SELECTION_ONE[@]}"; do
    ${AI[@]} ${PACKAGE}
done

echo -e "\nNetworking\n" | ${WTL[@]}
${AI[@]} --install-recommends net-tools
${AI[@]} --install-recommends network-manager*

echo -e "\nSecond selection of packages...\n" | ${WTL[@]}
for PACKAGE in "${PACKAGE_SELECTION_TWO[@]}"; do
    ${AI[@]} ${PACKAGE}
done

echo -e "\nFirefox\n" | ${WTL[@]}
${AI[@]} --no-install-recommends firefox

echo -e "\nThunderbird\n" | ${WTL[@]}
${AI[@]} thunderbird

echo -e "\nFonts - Roboto & OpenSans\n" | ${WTL[@]}
${AI[@]} fonts-roboto fonts-open-sans

echo -e "\nIcon Theme\n" | ${WTL[@]}
(
    cd "${DIR}/../resources/icon_theme/icon_theme.sh"
    &>>"${LOG}" find . -maxdepth 1 -iregex "[a-z0-9_\.\/\ ]*\w\.sh" -type f -exec chmod +x {} \;
    &>>"${LOG}" ./icon_theme.sh "$LOG"
)

echo -e 'Finished installing packages! Proceeding to removing dmenu...' | ${WTL[@]}

echo -e "\nDmenu\n" | ${WTL[@]}
&>>"${LOG}" sudo apt-get remove ${IF[@]} suckless-tools

echo -e 'Finished reoving packages! Proceeding to updating and upgrading via APT...' | ${WTL[@]}

&>>"${LOG}" sudo apt-get -qq -y update
&>>"${LOG}" sudo apt-get -qq -y upgrade

echo -e 'Finished with the actual script.' | ${WTL[@]}

# ? Actual script finished
# ? Extra script begins

echo -e 'Processing user-choices...' | ${WTL[@]}

## Graphics driver
if [[ $R1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R1 ]]; then
    echo -e 'Enabling ubuntu-drivers autoinstall...' | ${WTL[@]}
    &>>"${LOG}" sudo ubuntu-drivers autoinstall
fi

if [[ $R2 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R2 ]]; then
    if [[ $(lsb_release -r) == *"18.04"* ]]; then
        echo -e 'Installing OpenJDK 11...' | ${WTL[@]}
        ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
    else
        echo -e 'Installing OpenJDK 12...' | ${WTL[@]}
        ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
    fi
fi

if [[ $R3 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R3 ]]; then
    echo -e 'Installing Cryptomator...' | ${WTL[@]}
    &>>"${LOG}" sudo add-apt-repository -y ppa:sebastian-stenzel/cryptomator
    ${AI[@]} cryptomator
fi

if [[ $R4 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R4 ]]; then
    if [[ ! -e /etc/apt/sources.list.d/balena-etcher.list ]]; then
        sudo touch /etc/apt/sources.list.d/balena-etcher.list
    fi

    echo "deb https://deb.etcher.io stable etcher" | sudo > /etc/apt/sources.list.d/balena-etcher.list
    &>>"${LOG}" sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    ${AI[@]} balena-etcher-electron
fi

if [[ $R5 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R5 ]]; then
    echo -e 'Installing LaTeX...' | ${WTL[@]}
    ${AI[@]} texlive-full
fi

if [[ $R6 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R6 ]]; then
    echo -e 'Installing OwnCloud...' | ${WTL[@]}
    ${AI[@]} owncloud-client
fi

if [[ $R7 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R7 ]]; then
    echo -e 'Installing build-essential & cmake...' | ${WTL[@]}
    ${AI[@]} build-essential cmake
fi

if [[ $R8 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R8 ]]; then
    echo -e 'Installing RUST...' | ${WTL[@]}
    curl https://sh.rustup.rs -sSf | sh -s -- --profile complete
    if [[ -e "${HOME}/.cargo/bin/rustup"]]; then
        mkdir -p "${HOME}/.local/share/bash-completion/completions"
        touch "${HOME}/.local/share/bash-completion/completions/rustup"
        rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

        &>>"${LOG}" rustup set profile complete

        COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )

        for COMPONENT in ${COMPONENTS[@]}; do
            &>>"${LOG}" rustup component add $COMPONENT
        done

        &>>"${LOG}" rustup update
    fi
fi

if [[ $R9 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R9 ]]; then
    echo -e 'Installing VS Code...' | ${WTL[@]}
    ${SI[@]} code --classic
fi

if [[ $R10 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $R10 ]]; then
    echo -e "Installing JetBrains' IDE suite..." | ${WTL[@]}
    ${SI[@]} intellij-idea-ultimate --classic
    ${SI[@]} kotlin --classic
    ${SI[@]} kotlin-native --classic
    ${SI[@]} pycharm-professional --classic
    ${SI[@]} clion --classic
fi

if [[ $RC1 =~ ^(yes|Yes|y|Y| ) ]] || [[ -z $RC1 ]]; then
    echo -e 'Installing VS Code Extensions...' | ${WTL[@]}
    sudo chmod +x "${DIR}/resources/sys/vscode/extensions.sh"
    &>>"${LOG}" "${DIR}/resources/sys/vscode/extensions.sh"
fi

echo -e 'Finished with processing user-choices! One last update...' | ${WTL[@]}

&>>"${LOG}"sudo apt-get -qq -y update
&>>"${LOG}"sudo apt-get -qq -y upgrade
&>>"${LOG}"sudo snap refresh

# ? Extra script finished
# ? Postconfiguration and restart

echo -e "The script has finished!\nEnded at: $(date)\n\n" | ${WTL[@]}

for I in {5..1..-1}; do
    echo -ne "\rRestart in $I seconds"
    sleep 1
done
sudo shutdown -r now
