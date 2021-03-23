#! /bin/bash

EXTENSIONS=(
  2gua.rainbow-brackets
  aaron-bond.better-comments
  be5invis.toml
  bierner.markdown-preview-github-styles
  bungcip.better-toml
  DavidAnson.vscode-markdownlint
  dustypomerleau.rust-syntax
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  James-Yu.latex-workshop
  jetmartin.bats
  karunamurti.tera
  mads-hartmann.bash-ide-vscode
  matklad.rust-analyzer
  mikestead.dotenv
  ms-azuretools.vscode-docker
  ms-python.python
  ms-toolsai.jupyter
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-ssh-edit
  ms-vscode.cpptools
  PKief.material-icon-theme
  redhat.vscode-yaml
  ritwickdey.LiveServer
  rust-lang.rust
  sainnhe.gruvbox-material
  serayuzgur.crates
  shd101wyy.markdown-preview-enhanced
  skellock.just
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-german
  timonwong.shellcheck
  vadimcn.vscode-lldb
  VisualStudioExptTeam.vscodeintellicode
  xshrim.txt-syntax
  yzhang.markdown-all-in-one
)

for EXTENSION in "${EXTENSIONS[@]}"
do
  code --install-extension "${EXTENSION}"
done

