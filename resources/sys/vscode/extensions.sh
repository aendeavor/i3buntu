#!/usr/bin/env bash

# This script serves as the installation script
# for Visual Studio Code's extensions. It is run
# if the user chose to do so after chosing to
# install VS Code. A detailed overview of all
# installed extensions can be found under
# ./README.adoc. 
# 
# current version - 0.0.5

# ? Preconfig

if [[ -z $(which code) ]] || [[ ! -e "/snap/bin/code" ]]; then
    exit 1
fi

CODE=$(which code)

if [[ -z "${CODE}" ]]; then
    CODE="/snap/bin/code"
fi

INSTALL=( ${CODE} --install-extension )

# ? Preconfig finished
# ? Actual script begins

${INSTALL[@]} 2gua.rainbow-brackets
${INSTALL[@]} aaron-bond.better-comments
${INSTALL[@]} alefragnani.Bookmarks
${INSTALL[@]} bungcip.better-toml
${INSTALL[@]} bierner.markdown-preview-github-styles
${INSTALL[@]} DavidAnson.vscode-markdownlint
${INSTALL[@]} eamodio.gitlens
${INSTALL[@]} editorconfig.editorconfig
${INSTALL[@]} Equinusocio.vsc-material-theme
${INSTALL[@]} formulahendry.code-runner
${INSTALL[@]} James-Yu.latex-workshop
${INSTALL[@]} joaompinto.asciidoctor-vscode
${INSTALL[@]} ms-azuretools.vscode-docker
${INSTALL[@]} ms-python.python
${INSTALL[@]} ms-vscode-remote.remote-containers
${INSTALL[@]} ms-vscode-remote.remote-ssh
${INSTALL[@]} ms-vscode-remote.remote-ssh-edit
${INSTALL[@]} ms-vscode-remote.remote-wsl
${INSTALL[@]} ms-vscode-remote.vscode-remote-extensionpack
${INSTALL[@]} ms-vscode.cpptools
${INSTALL[@]} PKief.material-icon-theme
${INSTALL[@]} redhat.vscode-xml
${INSTALL[@]} redhat.vscode-yaml
${INSTALL[@]} ritwickdey.LiveServer
${INSTALL[@]} serayuzgur.crate
${INSTALL[@]} shd101wyy.markdown-preview-enhanced
${INSTALL[@]} stayfool.vscode-asciidoc
${INSTALL[@]} streetsidesoftware.code-spell-checker
${INSTALL[@]} streetsidesoftware.code-spell-checker-german
${INSTALL[@]} VisualStudioExptTeam.vscodeintellicode
${INSTALL[@]} yzane.markdown-pdf
${INSTALL[@]} yzhang.markdown-all-in-one


if [[ ! -z $(which rustup) ]]; then
    ${INSTALL[@]} rust-lang.rust
fi

# ? Actual script finished
# ? Postconfiguration

echo -e "Finished installing VS Code extensions!"
