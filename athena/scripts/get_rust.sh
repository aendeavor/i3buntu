#!/bin/bash

if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
then
	if [ -e "${HOME}/.cargo/env" ]; then
		# shellcheck source=/dev/null
		source "${HOME}/.cargo/env"

		mkdir -p "${HOME}/.local/share/bash-completion/completions"
		rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"

		local COMPONENTS=( rust-docs rust-analysis rust-src rustfmt rls clippy )
		for COMPONENT in "${COMPONENTS[@]}"; do
			&>>/dev/null rustup component add "$COMPONENT"
		done
	fi
else
	exit 1
fi
