# Ubuntu Minimal & i3

[//]: # (Serves an overview of i3buntu)
[//]: # (version 1.2.0)

## Preamble

This repository aims at providing you with a set of instructions to create your own minimal _Ubuntu_ installation with the _i3_[_-gaps_](https://github.com/Airblader/i3) window manager. The latest release of i3buntu is [v1.1.0-stable](https://github.com/aendeavor/i3buntu/releases/tag/v1.1.0-stable), the latest stable release is [v1.1.0-stable](https://github.com/aendeavor/i3buntu/releases/tag/v1.1.0-stable).

[![Desktop Theme](resources/doc/desktop_theme.png)](https://reddit.com/r/unixporn/)

## Installation instructions

Installation instructions are found [here](./INSTALL.md) or on the [wiki pages](https://github.com/aendeavor/i3buntu/wiki).

## About

### Reasoning

This project is all about improving your Linux experience and working environment. Therefore, _i3-gaps_ has been chosen as the window manager of choice. Tiling window managers improve or modify all areas of workflow, from design to efficiency. With _i3buntu_, _i3_ has been configured meticulously. Moreover, _i3_ and _X_ are much more lightweight compared to _GNOME_ or _KDE_. As a result, everything is faster.

The color scheme has been carefully chosen to implement into the system seamlessly. Every program, from the shell to your browser have adapted these changes. They are reflected in the choice of icons, backgrounds and windows.

During the packaging stage, the user is offered a variety of packages to install. These packages are all completely optional. For developers and command line users, _[BASH](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29)_ has been configured and extended with aliases, functions and parameters. In addition, the prompt has been reworked. If you like _Powerline_, you can enable it in `${HOME}/.bashrc`.

### Compatibility & Why Ubuntu

The following instructions are made for [Ubuntu](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#Ubuntu) / [Debian](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#General) based systems and are not compatible with other operating systems. Ubuntu has been chosen to provide every person with ease of use and stability.

Systems not based on Ubuntu, including but not limited to those using package-managers differing from APT or not supporting Snap, are not officially supported by this guide.

### Prerequisites

It is recommended to be familiar with the Linux environment, the command line and to have a basic knowledge about the file system structure. You should know what you are doing when working with administrator-privileges.

### Dependencies

* [Ubuntu 18.04 LTS](https://en.wikipedia.org/wiki/Ubuntu) Operating System
* [i3-gaps](https://github.com/Airblader/i3) Tiling Window Manager
* [Alacritty](https://github.com/alacritty/alacritty) Main Terminal Emulator
* [URXVT](https://wiki.archlinux.org/index.php/Rxvt-unicode) Fallback Terminal Emulator
* [APT](https://en.wikipedia.org/wiki/APT_(software)) Packaging Manager
* [X(org)](https://wiki.archlinux.org/index.php/Xorg) Display Server
* [LightDM](https://wiki.archlinux.org/index.php/LightDM) Display Manager
* [Nemo](https://wiki.archlinux.org/index.php/Nemo) File Manager

## Warranty

This guide and these files come with absolutely **no warranty**! The knowledge is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of unleashing indescribable horrors.
