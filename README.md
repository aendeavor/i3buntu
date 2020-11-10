# i3buntu

![version][version] ![stability][stability] ![lib][lib::version] ![bin][application::version]

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

The library provides all functions and methods as well as data structures our application uses. Moreover, all configuration files and software module descriptions are held here, as well as icons, logos and images.

### Licensing

This project is licensed under the [_GNU Lesser General Public License_](./LICENSE) version 3.

[//]: # (Badge Links)

[version]: https://img.shields.io/badge/version-v3.2.0-1A1D23?&style=for-the-badge
[stability]: https://img.shields.io/badge/stability-stable-FBB444?&style=for-the-badge

[lib::version]: https://img.shields.io/badge/library-v0.3.0-282D39?&style=for-the-badge
[application::version]: https://img.shields.io/badge/application-v0.4.2-5E6A82?&style=for-the-badge

[//]: # (Other Links)

[ubuntu::main]: https://ubuntu.com/
[i3gaps::github]: https://github.com/Airblader/i3
[rust::main]: https://www.rust-lang.org/
