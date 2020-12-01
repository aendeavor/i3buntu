# Server Deployment Guide

Server deployments are, obviously, quite different from desktop installations. As no graphical environment is needed, we can concentrate on the important programs and configs. These include

- Bash configuration
- (Neo)Vim configuration
- Docker
- Further packages

## Bash v5

Just copy [`.bashrc`](./../resources/config/home/.bashrc) and [`.bash_aliases`](./../resources/config/home/.bash_aliases). Afterwards, install `neofetch` with

``` BASH
sudo apt-get install neofetch
```

## NeoVim Configuration

Install NeoVim with

``` BASH
sudo apt-get install -y neovim python3-dev
```

Then, download the plugin-manager [_VimPlug_](https://github.com/junegunn/vim-plug) with

``` BASH
sh -c 'curl -fLo "${XDG_DATA_HOME:-${HOME}/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Afterwards, copy [`init.vim`](./../resources/config/home/.config/nvim/init.vim) to `~/.config/nvim/`. Open NeoVim and use the command `:PlugInstall` to install the plugins. You can then use the script `nvim_ycm.sh` in the [`scripts`](../scripts) directory to compile [_YouCompleteMe_](https://github.com/ycm-core/YouCompleteMe).

## Docker

You can install Docker with

``` BASH
sudo apt-get install docker.io
```

Docker Compose can be installed with the `rd.sh` script in the [`../scripts/`](../scripts) directory by executing

``` BASH
./rdv.sh --docker-compose
```

## Further packages

Useful packages include

- git
- libaio1
- cmake
- build-essential
