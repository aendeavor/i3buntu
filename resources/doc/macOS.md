# _macOS_ Installation Guide

[//]: # (source <https://scriptingosx.com/2019/02/install-bash-5-on-macos/>)

## _BASH 5_

After installing _macOS_ and setting everything up via a graphical user interface, we need to setup _bash_ properly. As _macOS_ ships with _bash 3.2_ because of licensing issues, we will download, compile and install _bash 5.0.x_ ourselves.

``` BASH
# this is BASH3
cd ${HOME}/Downloads
wget https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz
tar xvzf bash-5.0.tar.gz
cd bash-5.0

# check how many patches are currently available
# if this does not work, download and patch separately with `patch -p0 -i patches/bash50-0XX`
curl 'https://ftp.gnu.org/gnu/bash/bash-5.0-patches/bash50-[001-016]' | patch -p0

# configure and build BASH5
./configure
make
sudo make install

# select BASH as the default shell
chsh -s /bin/bash
```

You will now need to boot into recovery mode. While rebooting, during startup, press `CMD+Alt+R` to get into recovery mode. Then open a shell and execute `csrutil disable` and reboot. Check with `csrutil status` whether SIP is disabled.

Now we will need to move the old _bash3_ from `/bin` to always execute the new _bash5_.

``` BASH
cd /bin
sudo mv bash bash3
sudo ln -s /usr/local/bin/bash /bin/bash
```

After opening a new shell, we can check whether we now use _bash5_.

``` BASH
/usr/local/bin/bash --version
/usr/bin/env bash --version
bash --version
```

These should all show version 5. You can now, if you like, turn SIP back on, by following the steps to turning it of, just use `enable` instead of `disable`.

## Programs

``` BASH
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# If there are errors installing programs
# with brew, execute this
cd /usr/local/share/man
sudo chmod -R 775 *
cd /usr/local/share/locale
sudo chmod -R 775 *

# Install other programs
brew install neofetch
brew install neovim
brew install python3
brew install cmake
brew install htop

brew cask install visual-studio-code
brew cask install alacritty

brew tap homebrew/cask-fonts
brew cask install font-fira-code
```

## Configuration

You can download a patched version of `.bashrc` and `.bash_aliases` into `$HOME`. These will work with _bash5_. All other configuration can be downloaded and used with the command given below.

``` BASH
# BASH
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/sh/macOS/.bashrc > .bashrc
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/sh/macOS/.bash_aliases > .bash_aliases

# Alacritty
mkdir -p ${HOME}/.config/alacritty
cd ${HOME}/.config/alacritty
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/sh/macOS/alacritty.yml > alacritty.yml
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/completions/alacritty.bash > alacritty.bash
sudo tic -xe alacritty,alacritty-direct alacritty.info

# VS Code
_extensions=(
    2gua.rainbow-brackets
    aaron-bond.better-comments
    alefragnani.Bookmarks
    bungcip.better-toml
    bierner.markdown-preview-github-styles
    DavidAnson.vscode-markdownlint
    editorconfig.editorconfig
    Equinusocio.vsc-material-theme
    formulahendry.code-runner
    James-Yu.latex-workshop
    jolaleye.horizon-theme-vscode
    ms-azuretools.vscode-docker
    ms-python.python
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.cpptools
    PKief.material-icon-theme
    redhat.vscode-xml
    redhat.vscode-yaml
    ritwickdey.LiveServer
    sainnhe.gruvbox-material
    serayuzgur.crates
    shd101wyy.markdown-preview-enhanced
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-german
    vadimcn.vscode-lldb
    VisualStudioExptTeam.vscodeintellicode
    yzhang.markdown-all-in-one
)

printf "%-40s | %-15s | %-15s" "EXTENSION" "STATUS" "EXIT CODE"
echo ''
for _extension in ${_extensions[@]}; do
  &>>/dev/null code --install-extension ${_extension}
  EC=$?
  if (( $EC != 0 )); then
    printf "%-40s | %-15s | %-15s" "${_extension}" "Not Installed""${EC}"
  else
    printf "%-40s | %-15s | %-15s" "${_extension}" "Installed" "{EC}"
  fi
  echo ''
done

mkdir -p ${HOME}/Library/Application\ Support/Code/User
cd ${HOME}/Library/Application\ Support/Code/User
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/vscode/settings.json > settings.json

# NeoVIM
pip3 install pynvim
mkdir -p ${HOME}/.config/nvim
cd ${HOME}/.config/nvim
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/vi/init.vim > init.vim
# Install plugins in NeoVIm with :PlugInstall
# Next, compile YouCompleteMe with python3.X
cd ${HOME}/.config/nvim/plugged/YouCompleteMe
python3.X install.py
```
