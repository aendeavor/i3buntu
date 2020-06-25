# ![Apollo Logo](athena/style/apollo_logo.png)

## APOLLO

[![version](https://img.shields.io/badge/version-v0.1.0-green.svg)](https://shields.io/) [![stability](https://img.shields.io/badge/stability-unstable-red.svg)](https://shields.io/)

[//]: # (Main README in /)
[//]: # (version 0.1.0)

This repository provides means to customize an [_Ubuntu_](https://ubuntu.com/) installation. This project is all about the ease of bootstrapping settings and programs.

[![Desktop Theme](athena/docs/desktop_shell.png)](https://github.com/aendeavor/i3buntu)

### Installation Instructions

Are found in [`INSTALL.md`](INSTALL.md).

[![Collage 1](athena/docs/collage_1.png)](https://github.com/aendeavor/i3buntu)

### About

This project advances _i3buntu_, which was this project's name. We are trying to provide everyone with a single easy bootstrapping process for the installation of [_i3-gaps_](https://github.com/Airblader/i3) and other basic software.

### Submodules

[![Collage 2](athena/docs/collage_2.png)](https://github.com/aendeavor/i3buntu)

#### _Kyrene_

This submodule does the actual work and processes all request and tasks. The program is written entirely in [_RUST_](https://www.rust-lang.org/) and automatically invoked during installation. _Kyrene_ places all configuration files and installs the necessary software for you.

#### _Athena_

_Athena_ holds all configuration files and instructions which software to install. This is heavily used by _Kyrene_. Moreover, all icons, logos and images are stored there as well.

[![NeoVim](athena/docs/neovim.png)](https://github.com/aendeavor/i3buntu)

#### _Hermes_

Is there for you convenience and provides a simple forwarding mechanism via [apollo.itbsd.com](apollo.itbsd.com) to get the `init.sh` script. This script is executed before all the rest - it bootstraps this repository.

[![Nautilus](athena/docs/filemanager.png)](https://github.com/aendeavor/i3buntu)

### Warranty, Licensing & Credits

This project is licensed under the [_GNU Lesser General Public License_](LICENSE), version 3, 29 June 2007. For warranty and icon-, font- or logo-credits, see [Credits and Warranty](athena/docs/cw.md).
