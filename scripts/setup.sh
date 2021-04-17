#! /bin/bash

# version        0.1.0 [22 Mar 2021]
# executed by    curl | bash
# task           installs i3buntu

[[ ! ${EUID} -eq 0 ]] && { echo "Please start this script with sudo." >&2 ; exit 1 ; }

set -Eu -o pipefail

cd /tmp || exit 1

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Initial script configuration and directory setup
# ––
# ? >> Declaration and definition of setup functions
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

function add_ppas
{
  add-apt-repository -ny ppa:aslatter/ppa
  add-apt-repository -ny ppa:sebastian-stenzel/cryptomator
  add-apt-repository -ny ppa:regolith-linux/release

  wget -nv \
    'https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Ubuntu_20.04/Release.key' \
    -O - | sudo apt-key add -
  echo \
    'deb https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Ubuntu_20.04/ /' | \
    sudo tee -a /etc/apt/sources.list.d/owncloud.list

  wget \
    -qO- https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  echo \
    "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    >/etc/apt/sources.list.d/vscode.list
}

function install_packages
{
  apt-get -y install \
    alacritty \
    bat build-essential \
    cmake code cryptomator cups \
    eog evince \
    firefox fonts-firacode \
    gcc gnupg2 \
    libglib2.0-dev-bin \
    make \
    nautilus neofetch neovim \
    owncloud-client \
    p7zip-full python3-dev \
    regolith-desktop-standard regolith-look-gruvbox \
    thunderbird thunderbird-gnome-support \
    xz-utils # texlive-full
}

function install_rust
{
  if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  then
    return
  fi

  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
  
  mkdir -p "${HOME}/.local/share/bash-completion/completions"
  rustup completions bash >"${HOME}/.local/share/bash-completion/completions/rustup"
  
  for COMPONENT in rust-docs rust-analysis rust-src rustfmt rls clippy
  do
    rustup component add "${COMPONENT}"
  done

  if cargo install exa && [[ -e "${HOME}/.bash_aliases" ]]
  then
    sed -i -E \
      "s|(alias ls=')ls -lh --color=auto'|\1exa -b -h -l -g --git --group-directories-first'|g" \
      "${HOME}/.bash_aliases"
  fi
}

function install_docker_compose
{
  local COMPOSE_VERSION="1.28.5"
  sudo curl \
    -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  sudo curl \
    -L "https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose" \
    -o "/etc/bash_completion.d/docker-compose"
}

function purge_snapd
{
  command -v snap &>/dev/null || return 

  snap remove lxd
  snap remove core18
  snap remove snapd
  
  apt-get -y purge snapd
  rm -rf "${HOME}/snapd"
}

function place_configuration_files
{
  cd "${HOME}" || return 1
  local COMMON='https://raw.githubusercontent.com/aendeavor/i3buntu/development/'

  curl -S -L -o .bashrc \
    "${COMMON}resources/config/home/.bashrc"
  curl -S -L -o .bash_aliases \
    "${COMMON}resources/config/home/.bash_aliases"

  mkdir -p "${HOME}/.config/alacritty"
  curl -S -L -o .config/alacritty/alacritty.yml \
    "${COMMON}resources/config/home/.config/alacritty/alacritty.yml"


  mkdir -p "${HOME}/.config/regolith"
  cd "${HOME}/.config/regolith" || return 1
  mkdir -p i3 'i3xrocks/conf.d' picom

  curl -S -L -o Xresources \
    "${COMMON}resources/config/home/.config/regolith/Xresources"

  curl -S -L -o i3/config \
    "${COMMON}resources/config/home/.config/regolith/i3/config"
  
  curl -S -L -o picom/config \
    "${COMMON}resources/config/home/.config/regolith/picom/config"

  curl -S -L -o i3xrocks/conf.d/01_setup \
    "${COMMON}resources/config/home/.config/regolith/i3xrocks/conf.d/01_setup"
  curl -S -L -o i3xrocks/conf.d/70_battery \
    "${COMMON}resources/config/home/.config/regolith/i3xrocks/conf.d/70_battery"
  curl -S -L -o i3xrocks/conf.d/80_rofication \
    "${COMMON}resources/config/home/.config/regolith/i3xrocks/conf.d/80_rofication"
  curl -S -L -o i3xrocks/conf.d/90_time \
    "${COMMON}resources/config/home/.config/regolith/i3xrocks/conf.d/90_time"
}

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Declaration and definition of setup functions
# ––
# ? >> Execution of setup functions
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

function __main
{
  purge_snapd

  add_ppas
  apt-get update && apt-get -y dist-upgrade
  install_packages

  place_configuration_files

  regolith-look set gruvbox
  regolith-look refresh

  # install_rust
  # install_docker_compose
}

__main
