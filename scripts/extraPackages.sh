#!/bin/bash

# ! HANDLES INSTALLATION OF USER-SPECIFIC PACKAGES

# ? Preconfig

IF=( --yes --assume-yes --allow-unauthenticated --allow-downgrades --allow-remove-essential --allow-change-held-packages )
AI=( sudo apt-get install ${IF[@]} )
AA=( sudo add-apt-repository )
SI=( sudo snap install )

ubuntuVersion=$(lsb_release -r)

# ? Preconfig finished
# ? Actual script begins


##  APT repositories
${AA[@]} ppa:ubuntu-mozilla-security/ppa
${AA[@]} ppa:git-core/ppa
${AA[@]} ppa:sebastian-stenzel/cryptomator

echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61

sudo apt-get update


##  APT installations
${AI[@]} texlive-full
${AI[@]} firefox thunderbird
${AI[@]} git
${AI[@]} owncloud-client
${AI[@]} cryptomator
${AI[@]} balena-etcher-electron
${AI[@]} arandr
${AI[@]} build-essential cmake
${AI[@]} arandr


## Graphic driver
sudo ubuntu-drivers autoinstall


## Java
if [[ $ubuntuVersion == *"18.04"* ]]; then
    ${AI[@]} openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source
else
    ${AI[@]} openjdk-12-jdk openjdk-12-demo openjdk-12-doc openjdk-12-jre-headless openjdk-12-source
fi


## SNAP installations
${SI[@]} code --classic
${SI[@]} intellij-idea-ultimate --classic
${SI[@]} kotlin --classic
${SI[@]} kotlin-native --classic
${SI[@]} pycharm-professional --classic
${SI[@]} clion --classic
${SI[@]} spotify
${SI[@]} vlc


##  Others
curl https://sh.rustup.rs -sSf | sh
# * rustup component add rustfmt
# * rustup component add clippy
# * rustup component add rls
# * rustup component add clippy

