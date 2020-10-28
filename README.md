# i3buntu

![version][version] ![stability][stability]
![lib][lib::version] ![provider][provider::version] ![bin][application::version]

1. [Introduction](#introduction)
2. [Installation Instructions](./INSTALL.md)
3. [About This Repository](#about-this-repository)
4. [Licensing](#licensing)

## Introduction

i3buntu  provides means to customize an [_Ubuntu_][ubuntu::main] installation by deploying the needed programs and sensible default settings.

![Desktop Theme](library/docs/desktop_shell.png)

### Installation Instructions

Are found in [`INSTALL.md`](INSTALL.md).

![Notifications](library/docs/notifications.png)

### About This Repository

We are providing everyone with a single easy bootstrapping process for the installation of [_i3-gaps_][i3gaps::github] and other basic software.

![Collage 1](library/docs/collage_1.png)

#### Submodules

##### Application

The application essentially is the binary which does the actual job at runtime. Like all other projects in this repository, it is written in [_Rust_][rust::main].

##### Library

The library provides the base library our application uses. Moreover, all configuration files and software module descriptions are held here, as well as icons, logos and images.

##### Provider

The provider makes a forwarding mechanism via [i3buntu.itbsd.com][provider::url] available to download and execute `init.sh`. This script acquires the latest stable release candidate and starts the application.

### Licensing

This project is licensed under the [_GNU Lesser General Public License_](./LICENSE), version 3, 29 June 2007.

[//]: # (Badge Links)

[version]: https://img.shields.io/badge/version-v2.3.1-1A1D23?&style=for-the-badge
[stability]: https://img.shields.io/badge/stability-stable-FBB444?&style=for-the-badge

[lib::version]: https://img.shields.io/badge/library-v0.2.6-282D39?&style=for-the-badge
[provider::version]: https://img.shields.io/badge/provider-v0.1.2-434c5e?&style=for-the-badge
[application::version]: https://img.shields.io/badge/application-v0.4.1-5E6A82?&style=for-the-badge

[//]: # (Other Links)

[ubuntu::main]: https://ubuntu.com/
[i3gaps::github]: https://github.com/Airblader/i3
[rust::main]: https://www.rust-lang.org/

[provider::url]: https://i3buntu.itbsd.com
