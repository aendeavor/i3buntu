# _macOS_ Installation Guide

[//]: # (source <https://scriptingosx.com/2019/02/install-bash-5-on-macos/>)

## _BASH 5_

After installing and configuring _macOS_, we need to setup _Bash_ properly. As _macOS_ ships with _Bash v3.2_ because of licensing issues, we will download, compile and install _Bash v5.x.x_ ourselves.

``` BASH
# currently Bash v3
NBV='5.0'
cd ${HOME}/Downloads
curl "https://ftp.gnu.org/gnu/bash/bash-${NBV}.tar.gz" -o "bash-${NBV}.tar.gz"
tar xvzf "bash-${NBV}.tar.gz"
cd "bash-${NBV}"

# check how many patches are currently available
# if this does not work, download and patch
# separately with `curl ... && patch -p0 -i patches/bash50-0XX`
curl "https://ftp.gnu.org/gnu/bash/bash-${NBV}-patches/bash50-[001-016]" | patch -p0

./configure
make
sudo make install

chsh -s /bin/bash
```

You will now need to boot into recovery mode. While rebooting, during startup, press `Command (⌘)-R` to get into recovery mode. Then open a shell and execute `csrutil disable` and reboot. Check with `csrutil status` whether SIP is disabled. We will now rename the old `bash` to `bash3` and softlink the new `/bin/bash` to `/usr/local/bin/bash`, which is _Bash v5_.

``` BASH
cd /bin
sudo mv bash bash3
sudo ln -s /usr/local/bin/bash /bin/bash
```

After opening a new shell, we can check whether we now use _Bash v5_.

``` BASH
/usr/local/bin/bash --version
/usr/bin/env bash --version
/bin/bash --version
bash --version
```

These should all show version 5. While SIP is disabled, get rid of preinstalled applications we do not need, like chess, etc. Then, turn SIP back on, by following the steps to turning it of, just use `enable` instead of `disable`.

## _Homebrew_ & Programs

With _[Homebrew](https://brew.sh/)_, we can install all other programs we need, i.e. _Visual Studio Code_, _Git_, _NeoVim_, etc. Furthermore, we will be installing _FiraCode_, a special coding font.

[//]: # (cask sources https://formulae.brew.sh/cask/)

``` BASH
# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# if there are errors, execute this
cd /usr/local/share/man && sudo chmod -R 775 *
cd /usr/local/share/locale && sudo chmod -R 775 *

for PROG in neofetch python3 cmake neovim htop gpg pinentry-mac
do
  brew install "${PROG}"
done

BCI=(
    thunderbird
    firefox
    visual-studio-code
    alacritty
    cryptomator
    owncloud
)

for PROG in ${BCI[@]}
do
  brew cask install "${PROG}"
done

brew tap homebrew/cask-fonts
brew cask install font-fira-code
```

Other programs we will not be installing with _Homebrew_ are _Rust_.

``` BASH
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
mkdir -p ${HOME}/.local/share/bash-completion/completions/
rustup completions bash > "${HOME}/.local/share/bash-completion/completions/rustup"
rustup completions bash cargo > "${HOME}/.local/share/bash-completion/completions/cargo"
```

## Configuration

You can download a patched version of `.bashrc` and `.bash_aliases` into `$HOME`. These will work with _Bash v5_. All other configuration files can also be downloaded and used with the commands given below.

``` BASH
# BASH
cd
GCU="https://raw.githubusercontent.com/aendeavor/i3buntu/master/library/resources/config/macOS"
curl "${GCU}/.bashrc" > .bashrc
curl "${GCU}/.bash_aliases" > .bash_aliases

# Alacritty
mkdir -p "${HOME}/.config/alacritty" && cd "${HOME}/.config/alacritty"
curl "${GCU}/alacritty.yml" > alacritty.yml
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/completions/alacritty.bash > alacritty.bash
sudo tic -xe alacritty,alacritty-direct alacritty.info

# VS Code
mkdir -p "${HOME}/Library/Application Support/Code/User"
cd "${HOME}/Library/Application Support/Code/User"
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/vscode/settings.json > settings.json

EXTENSIONS=(
  "2gua.rainbow-brackets"
  "aaron-bond.better-comments"
  "azemoh.one-monokai"
  "be5invis.toml"
  "bierner.markdown-preview-github-styles"
  "DavidAnson.vscode-markdownlint"
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "karunamurti.tera"
  "James-Yu.latex-workshop"
  "mads-hartmann.bash-ide-vscode"
  "ms-kubernetes-tools.vscode-kubernetes-tools"
  "ms-python.python"
  "ms-vscode-remote.remote-ssh"
  "ms-vscode-remote.remote-ssh-edit"
  "ms-vscode.cpptools"
  "pkief.material-icon-theme"
  "redhat.vscode-xml"
  "redhat.vscode-yaml"
  "rust-lang.rust"
  "serayuzgur.crates"
  "shd101wyy.markdown-preview-enhanced"
  "streetsidesoftware.code-spell-checker"
  "streetsidesoftware.code-spell-checker-german"
  "timonwong.shellcheck"
  "vadimcn.vscode-lldb"
  "VisualStudioExptTeam.vscodeintellicode"
  "xshrim.txt-syntax"
  "yzhang.markdown-all-in-one"
  "zhuangtongfa.Material-theme"
)

for EXT in "${EXTENSIONS[@]}"
do
  if code --install-extension "${EXT}" &>/dev/null
  then
    printf "%-40s | %-15s | %-15s\n" "${EXT}" "Installed" "${EC}"
  else
    printf "%-40s | %-15s | %-15s\n" "${EXT}" "Not Installed" "${EC}"
  fi
done

# NeoVIM
pip3 install pynvim
mkdir -p "${HOME}/.config/nvim"
cd "${HOME}/.config/nvim"
curl https://raw.githubusercontent.com/aendeavor/i3buntu/master/resources/sys/vi/init.vim > init.vim
# Install plugins in NeoVIm with :PlugInstall,
# next, compile YouCompleteMe with python3.X
cd "${HOME}/.config/nvim/plugged/YouCompleteMe"
python3 install.py
```

### Thunderbird

We already downloaded `pinentry-mac` to serve as a graphical interface for _GnuPG_ when we want to sign and encrypt E-Mails with _Thunderbird_. We have to make sure this program is used when signing and encrypting.

```BASH
cd .gnupg
touch gpg-agent.conf
echo "pinentry-program /usr/local/bin/pinentry-mac" >> gpg-agent.conf
```
