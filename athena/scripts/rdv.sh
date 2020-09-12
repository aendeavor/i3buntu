#!/bin/bash

# Installs Rust and Docker
# Compose during packaging
# (stage 3) when APOLLO is
# processing user choices.
#
# author   Georg Lauterbach
# version  0.1.0 stable

function rust()
{
  if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  then
    if [[ -e "${HOME}/.cargo/env" ]]
    then
      # shellcheck source=/dev/null
      source "${HOME}/.cargo/env"

      mkdir -p "${HOME}/.local/share/bash-completion/completions"
      rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

      local COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
      for COMPONENT in "${COMPONENTS[@]}"
      do
        rustup component add "$COMPONENT" &>/dev/null
      done
    fi
  else
    return 1
  fi
}

function dockerc()
{
  local _compose_version="1.26.2"
  sudo curl \
    -L "https://github.com/docker/compose/releases/download/${_compose_version}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  sudo curl \
    -L "https://raw.githubusercontent.com/docker/compose/${_compose_version}/contrib/completion/bash/docker-compose" \
    -o "/etc/bash_completion.d/docker-compose"
}

function visual_studio_code()
{
  cd /tmp || return 1

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  sudo apt-get install apt-transport-https
  sudo apt-get update
  sudo apt-get install code
}


function main()
{
  case $1 in
    '--rust' ) rust ;;
    '--docker-compose' ) dockerc ;;
    '--visual-studio-code' ) visual_studio_code ;;
  esac
}

main "$@" || exit ${?}
