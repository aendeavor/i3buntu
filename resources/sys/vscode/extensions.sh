#!/usr/bin/env bash

# This script serves as the installation script
# for Visual Studio Code's extensions. It is run
# if the user chose to do so after chosing to
# install VS Code. A detailed overview of all
# installed extensions can be found under
# ./README.adoc. 
# 
# current version - 0.3.1 stable

# ? Preconfig

## directory of this file - absolute & normalized
SCR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
## return pointer
RIP=$1

# initiate aliases and functions
. "${SCR}/../sh/.bash_aliases"

# ? Checks

if [[ -z $(which code) ]] && [[ ! -e "/snap/bin/code" ]]; then
    err 'VS Code is not installed. Aborting the installation of extensions'
    exit 1
fi

CODE=$(which code)

if [[ -z "${CODE}" ]]; then
    CODE="/snap/bin/code"
fi

INSTALL=( ${CODE} --install-extension )

# ? Preconfig finished
# ? Selection of extions

EXT=(
    2gua.rainbow-brackets
    aaron-bond.better-comments
    alefragnani.Bookmarks
    bungcip.better-toml
    bierner.markdown-preview-github-styles
    DavidAnson.vscode-markdownlint
    eamodio.gitlens
    editorconfig.editorconfig
    Equinusocio.vsc-material-theme
    formulahendry.code-runner
    James-Yu.latex-workshop
    joaompinto.asciidoctor-vscode
    jolaleye.horizon-theme-vscode
    ms-azuretools.vscode-docker
    ms-python.python
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-wsl
    ms-vscode-remote.vscode-remote-extensionpack
    ms-vscode.cpptools
    PKief.material-icon-theme
    redhat.vscode-xml
    redhat.vscode-yaml
    ritwickdey.LiveServer
    sainnhe.gruvbox-material
    serayuzgur.crate
    shd101wyy.markdown-preview-enhanced
    stayfool.vscode-asciidoc
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-german
    VisualStudioExptTeam.vscodeintellicode
    yzane.markdown-pdf
    yzhang.markdown-all-in-one
    jolaleye.horizon-theme-vscode
)

# ? Selection of extensions finished
# ? Actual script begins

printf "%-40s | %-15s | %-15s" "EXTENSION" "STATUS" "EXIT CODE"
printf "\n"

for EXTENSION in ${EXT[@]}; do
    &>>/dev/null ${INSTALL[@]} ${EXTENSION}

    EC=$?
    if (( $EC != 0 )); then
        printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Not Installed" "${EC}"
    else
        printf "%-40s | %-15s | %-15s" "${EXTENSION}" "Installed" "${EC}"
        printf "\n"
    fi
done

if [[ ! -z $(which rustup) ]]; then
    &>>/dev/null ${INSTALL[@]} rust-lang.rust

    if (( $? == 0 )); then
        inform 'As RUST is installed, we successfully installed rust-lang for VS Code too'
    fi
fi

if [[ ! -z $(which gem) ]]; then
     sudo gem install asciidoctor-pdf --pre
fi

# ? Actual script finished
# ? Postconfiguration

inform 'Finished installing VS Code extensions'
