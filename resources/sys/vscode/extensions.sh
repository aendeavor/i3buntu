#!/usr/bin/env bash

# This script serves as the installation script
# for Visual Studio Code's extensions. It is run
# if the user chose to do so after chosing to
# install VS Code. A detailed overview of all
# installed extensions can be found under
# ./README.adoc. 
# 
# current version - 0.0.4

# ? Preconfig

if [[ -z $(which code) ]] || [[ ! -e "/snap/bin/code" ]]; then
    exit 1
fi

CODE=$(which code)

if [[ -z "${CODE}" ]]; then
    CODE="/snap/bin/code"
fi

echo $CODE

# ? Preconfig finished
# ? Actual script begins

# ? Actual script finished
# ? Extra script begins

# ? Extra script finished
# ? Postconfiguration
