#!/usr/bin/env bash

# This script serves as the installation script
# for Visual Studio Code's extensions. It is run
# if the user chose to do so after chosing to
# install VS Code. A detailed overview of all
# installed extensions can be found under
# ./README.adoc. 
# 
# current version - 0.6.0 unstable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck source=../sh/.bash_aliases
. "${SCR}/../sh/.bash_aliases"

# ? Selection of extensions

EXT=(
    2gua.rainbow-brackets
    aaron-bond.better-comments
    alefragnani.Bookmarks
    bungcip.better-toml
    bierner.markdown-preview-github-styles
    DavidAnson.vscode-markdownlint
    editorconfig.editorconfig
    Equinusocio.vsc-material-theme
    formulahendry.code-runner
    karunamurti.tera
    James-Yu.latex-workshop
	jolaleye.horizon-theme-vscode
	mads-hartmann.bash-ide-vscode
    ms-azuretools.vscode-docker
    ms-python.python
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.cpptools
    PKief.material-icon-theme
	remisa.shellman
    redhat.vscode-xml
    redhat.vscode-yaml
    ritwickdey.LiveServer
    sainnhe.gruvbox-material
    serayuzgur.crates
    shd101wyy.markdown-preview-enhanced
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-german
	timonwong.shellcheck
    vadimcn.vscode-lldb
    VisualStudioExptTeam.vscodeintellicode
    yzhang.markdown-all-in-one
)

# ? Actual script

check_code() {
	if [ -z "$(which code)" ] && [ ! -e "/snap/bin/code" ]; then
	    err 'VS Code is not installed. Aborting the installation of extensions'
	    exit 1
	fi

	CODE=$(which code); [ -z "${CODE}" ] && CODE="/snap/bin/code"
	INSTALL=( "${CODE}" --install-extension )
}

install_extensions() {
	printf "%-40s | %-15s | %-15s" "EXTENSION" "STATUS" "EXIT CODE"
    echo ''

	for EXTENSION in "${EXT[@]}"; do
		&>>/dev/null "${INSTALL[@]}" "${EXTENSION}"

		EC=$?
		if (( EC != 0 )); then
			printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Not Installed" "${EC}"
		else
			printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Installed" "${EC}"
		fi
		
        echo ''
	done

	if [ -n "$(which rustup)" ]; then
		if &>>/dev/null "${INSTALL[@]}" rust-lang.rust; then
			inform 'As RUST is installed, we successfully installed rust-lang for VS Code too'
		fi
	fi
	
	inform 'Finished installing VS Code extensions'
}

# ! Main

main() {
	check_code
	install_extensions
}

main "$@" || exit 1
