#! /bin/bash

# version        0.1.0 [22 Mar 2021]
# executed by    curl | bash
# task           installs i3buntu

set -eEu -o pipefail

cd /tmp
sudo su

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Initial script configuration and directory setup
# ––
# ? >> Setup of default and global values / variables
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Setup of default and global values / variables
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
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
}

function install_packages
{
  apt-get -y install \
    alacritty \
    bat build-essential \
    cmake code cryptomator \
    eog \
    firefox fonts-firacode \
    gcc gnupg2 \
    libglib2.0-dev-bin \
    make \
    nautilus neofetch neovim \
    owncloud-client \
    p7zip-full python3-dev \
    regolith-desktop-standard regolith-look-gruvbox \
    thunderbird thunderbird-gnome-support \
    xz-utils
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
  sed -i \
    "s|(alias ls=')ls -lh --color=auto'|\1exa -b -h -l -g --git'|g" \
    "${HOME}/.bash_aliases"

  sed -i \
    "s|(alias lsa=')ls -lhA --color=auto'|\1exa -b -h -l -g --git -a'|g" \
    "${HOME}/.bash_aliases"
  fi
}

function _install_compose
{
  local _compose_version="1.28.5"
  sudo curl \
  -L "https://github.com/docker/compose/releases/download/${_compose_version}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  sudo curl \
  -L "https://raw.githubusercontent.com/docker/compose/${_compose_version}/contrib/completion/bash/docker-compose" \
  -o "/etc/bash_completion.d/docker-compose"
}

function purge_snapd
{
  snap remove lxd || :
  snap remove core18 || :
  snap remove snapd || :
  apt-get -y purge snapd
  rm -rf "${HOME}/snapd"
}

function place_configuration_files
{
  cd "${HOME}"

  curl -S -L -o .bashrc \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
  curl -S -L -o .bash_aliases \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh

  mkdir -p "${HOME}/.config/alacritty"
  curl -S -L -o .config/alacritty/alacritty.yml \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh

  mkdir -p "${HOME}/.config/regolith"
  cd "${HOME}/.config/regolith"
  mkdir -p i3 'i3xrocks/conf.d' picom

  curl -S -L -o Xresources \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh

  curl -S -L -o i3/config \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
  
  curl -S -L -o picom/config \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh

  curl -S -L -o i3xrocks/conf.d/01_setup \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
  curl -S -L -o Xi3xrocks/conf.d/70_battery \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
  curl -S -L -o Xi3xrocks/conf.d/80_rofication \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
  curl -S -L -o Xi3xrocks/conf.d/90_time \
   https://raw.githubusercontent.com/aendeavor/i3buntu/master/scripts/lib/logs.sh
}

# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# ? << Declaration and definition of setup functions
# ––
# ? >> Execution of setup functions
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

purge_snapd
add_ppas
apt-get update
apt-get -y dist-upgrade
install_packages
place_configuration_files
regolith-look set gruvbox
regolith-look refresh

install_rust

