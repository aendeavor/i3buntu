# ![Apollo Logo](athena/docs/apollo_logo.png)

## APOLLO

![version][version] ![stability][stability] ![athena][version::athena] ![hermes][version::hermes] ![kyrene][version::kyrene]

1. [Introduction](#introduction)
2. [Installation Instructions](./INSTALL.md)
3. [About](#about)
   1. [Kyrene](#kyrene)
   2. [Athena](#athena)
   3. [Hermes](#hermes)
4. [Warranty](#warranty-licensing--credits)

[//]: # (Main README in /)
[//]: # (version 0.3.1)

### Introduction

i3buntu  provides means to customize an [_Ubuntu_](https://ubuntu.com/) installation by deploying the needed programs and sensible default settings. ***APOLLO*** is the name of the current working environment.

![Desktop Theme](athena/docs/desktop_shell.png)

### Installation Instructions

Are found in [`INSTALL.md`](INSTALL.md).

![Notifications](athena/docs/notifications.png)

### About

The ***APOLLO*** project advances _i3buntu_. We are providing everyone with a single easy bootstrapping process for the installation of [_i3-gaps_](https://github.com/Airblader/i3) and other basic software.

![Collage 1](athena/docs/collage_1.png)

#### Submodules

![NeoVim](athena/docs/neovim.png)

##### _Kyrene_

_Kyrene_ holds the binary which does the actual job at runtime. Like all other projects in this repository, it is written in [_Rust_](https://www.rust-lang.org/).

##### _Athena_

_Athena_ provides the base library _Kyrene_ uses. Moreover, all configuration files and software module descriptions are held here, as well as icons, logos and images.

##### _Hermes_

_Hermes_ provides a forwarding mechanism via [apollo.itbsd.com](https://apollo.itbsd.com) to download and execute `init.sh`. This script acquires the latest stable release candidate and starts ***APOLLO***.

### Warranty, Licensing & Credits

This project is licensed under the [_GNU Lesser General Public License_](./LICENSE), version 3, 29 June 2007. For warranty and icon-, font- or logo-credits, see [Credits and Warranty](athena/docs/cws.md).

[//]: # (Links)

[version]: https://img.shields.io/badge/version-v2.3.1-1A1D23.svg
[stability]: https://img.shields.io/badge/stability-stable-FBB444.svg
[version::athena]: https://img.shields.io/badge/athena-v0.2.6-434c5e.svg
[version::hermes]: https://img.shields.io/badge/hermes-v0.1.2-434c5e.svg
[version::kyrene]: https://img.shields.io/badge/kyrene-v0.4.1-5E6A82.svg
