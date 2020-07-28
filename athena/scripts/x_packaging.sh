#!/bin/bash

function choices() {

	read -p 'Would you like to install VS Code? [Y/n]' -r VSC
	read -p 'Would you like to install recommended VS Code extensions? [Y/n]' -r VSCE
	read -p 'Would you like to install RUST? [Y/n]' -r RUST

}

## installs icon theme and colorpack
function tela() {
	if [[ ! -d "${HOME}/.local/share/icons/Tela" ]]; then
	    inform 'Icon-Theme is being processed' "$LOG"
        (
          cd /tmp || exit 1
          wget\
            -O tela.tar.gz\
            "https://github.com/vinceliuice/Tela-icon-theme/archive/2020-05-12.tar.gz" >/dev/null || exit 1

          tar -xvzf "tela.tar.gz" &>>/dev/null
          mv Tela* tela
          cd /tmp/tela/ || return 1
          ./install.sh grey >/dev/null 2>>"${LOG}"
        )
	fi

	(
		mkdir -p "${HOME}/.themes" &>/dev/null
		cp "${DIR}/../design/nordic_darker.tar.xz" "${HOME}/.themes"
		cd "${HOME}/.themes" || return 1
		tar -xf nordic_darker.tar &>/dev/null
	)
}

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

function main()
{
	case $1 in
		'tela') tela ;;
	esac
}

main "$@" || exit 1
