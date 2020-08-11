#!/bin/bash

function rust()
{
	if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	then
		if [ -e "${HOME}/.cargo/env" ]; then
			# shellcheck source=/dev/null
			source "${HOME}/.cargo/env"

			mkdir -p "${HOME}/.local/share/bash-completion/completions"
			rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

			local COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
			for COMPONENT in "${COMPONENTS[@]}"; do
				rustup component add "$COMPONENT" &>/dev/null
			done
		fi
	else
		exit 1
	fi
}

function dockerc()
{
  	local _compose_version="1.26.2"
	sudo curl\
  		-L "https://github.com/docker/compose/releases/download/${_compose_version}/docker-compose-$(uname -s)-$(uname -m)"\
    	-o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

	sudo curl\
  		-L "https://raw.githubusercontent.com/docker/compose/${_compose_version}/contrib/completion/bash/docker-compose"\
    	-o "/etc/bash_completion.d/docker-compose"
}

function main()
{
	case $1 in
		'--rust' ) rust ;;
		'--docker-compose' ) dockerc ;;
	esac
}

main "$@" || exit 1
