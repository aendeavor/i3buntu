# ![Apollo Logo](athena/docs/apollo_logo.png)

## APOLLO

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-unstable-FBB444.svg) ![athena](https://img.shields.io/badge/athena-v0.2.4-2B303B.svg) ![hermes](https://img.shields.io/badge/hermes-v0.1.2-434c5e.svg) ![version](https://img.shields.io/badge/kyrene-v0.3.8-5E6A82.svg)

[//]: # (Main README in /)
[//]: # (version 0.2.2)

i3buntu provides means to customize an [_Ubuntu_](https://ubuntu.com/) installation by deploying the needed programs and sensible default settings.

![Desktop Theme](athena/docs/desktop_shell.png)

### Installation Instructions

Are found in [`INSTALL.md`](INSTALL.md).

![Notifications](athena/docs/notifications.png)

### About

![Collage 1](athena/docs/collage_1.png)

The ***APOLLO*** project advances _i3buntu_. We are trying to provide everyone with a single easy bootstrapping process for the installation of [_i3-gaps_](https://github.com/Airblader/i3) and other basic software.

#### Submodules

![NeoVim](athena/docs/neovim.png)

##### _Kyrene_

_Kyrene_ holds the binary which does the actual job at runtime. Like all other projects in this repository, it is written in [_Rust_](https://www.rust-lang.org/).

##### _Athena_

_Athena_ provides the base library _Kyrene_ uses. Moreover, all configuration files and software module descriptions are held here, as well as icons, logos and images.

##### _Hermes_

_Hermes_ provides a forwarding mechanism via [apollo.itbsd.com](https://apollo.itbsd.com) to download and execute `init.sh`. This script acquires the latest stable release candidate and starts ***APOLLO***.

### Warranty, Licensing & Credits

![Collage 2](athena/docs/collage_2.png)

This project is licensed under the [_GNU Lesser General Public License_](LICENSE), version 3, 29 June 2007. For warranty and icon-, font- or logo-credits, see [Credits and Warranty](athena/docs/cws.md).
