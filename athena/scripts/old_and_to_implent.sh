#!/bin/bash

function i_docker()
{
	test_on_success "$LOG" "${AI[@]}" docker.io
  sudo systemctl enable --now docker
	sudo usermod -aG docker "$(whoami)"

  local _compose_version="1.26.0"
	sudo curl\
  	-L "https://github.com/docker/compose/releases/download/${_compose_version}/docker-compose-$(uname -s)-$(uname -m)"\
    -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo curl\
  	-L https://raw.githubusercontent.com/docker/compose/${_compose_version}/contrib/completion/bash/docker-compose\
    -o /etc/bash_completion.d/docker-compose
}

## processes user-choices from the beginning
function i_rust() {
	if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile complete -y
	then
		if [ -e "${HOME}/.cargo/env" ]
		then
			# shellcheck source=/dev/null
			source "${HOME}/.cargo/env"

			mkdir -p "${HOME}/.local/share/bash-completion/completions"
			rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

			local COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
			for COMPONENT in "${COMPONENTS[@]}"; do
				&>>/dev/null rustup component add "$COMPONENT"
			done
		fi
	fi
}

# ! x_configuration

		mkdir -p "${HOME}/.config/nvim"
		sudo mkdir -p "/root/.config/nvim"
		echo -e "-> Syncing NeoVIM's configuration"
		{
			"${RS[@]}" "${SYS}/vi/.vimrc" "${HOME}"
			sudo "${RS[@]}" "${SYS}/vi/.vimrc" "/root"

			sudo "${RS[@]}" "${SYS}/vi/init.vim" "/root/.config/nvim"
			"${RS[@]}" "${SYS}/vi/init.vim" "${HOME}/.config/nvim"

			curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    		curl -fLo '/root/.local/share/nvim/site/autoload/plug.vim' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		} >/dev/null 2>>"${LOG}"

		echo ''
		warn "You will need to run :PlugInstall seperately in NeoVIM\n\t\t\tas you cannot execute this command in a shell.\n\t\t\tThereafter, run python3 ~/.config/nvim/plugged/YouCompleteMe/install.py"


	inform 'Reloading X-services'
	xrdb "${HOME}/.Xresources" &>/dev/null


# ! Server packaging

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
    git
)

ENV=(
    htop
    tmux
)

MISC=(
    xsel
    xclip

    neofetch

    ncdu
	ripgrep
    python3-dev
)

function choices() {
	inform "Please make your choices:\n"

	read -p "Would you like to execute ubuntu-driver autoinstall? [Y/n]" -r UDA
	read -p "Would you like to install Build-Essentials? [Y/n]" -r BE
	read -p "Would you like to install NeoVIM? [Y/n]" -r NVIM

	DOCK="n"
	[ -z "$(command -v docker)" ] && read -p "Would you like to install Docker/Compose? [Y/n]" -r DOCK

	read -p "Would you like to install RUST? [Y/n]" -r RUST

	echo ''
}

sudo add-apt-repository -y ppa:git-core/ppa

