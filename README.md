# Ubuntu Minimal & i3

[//]: # (Serves an overview of i3buntu)
[//]: # (version 1.0.1)

## Preamble

This repository aims at providing you with a set of instructions to create your own minimal Ubuntu installation with the i3 window manager. If you want to learn about i3buntu's features, there is a dedicated [FEATURES](./resources/doc/FEATURES.adoc) file. The latest release of i3buntu is [v1.0.0-unstable](https://github.com/aendeavor/i3buntu/releases/tag/v1.0.0-unstable), the latest stable release is [v0.9.3-stable](https://github.com/aendeavor/i3buntu/releases/tag/v0.9.3-stable).

[![Desktop Theme](resources/doc/desktop_theme.png)](https://www.reddit.com/r/unixporn/)

## Installation instructions

Installation instructions are found [here](./INSTALL.md) or on the [wiki pages](https://github.com/aendeavor/i3buntu/wiki).

## Latest enhancements

##### Alacritty

The terminal emulator _Alacritty_ has been integrated. It features true-color support, is written in _RUST_ and is GPU-accelerated.

##### Build script with functions

Bash scripts now properly work with functions. Further information is found in [INSTALL.md](./INSTALL.md).

##### NeoVIM reworked

NeoVim has been fully reworked to make use of a brand new theme, _OceanicNext_. TrueColors are now enabled, the configuration has been reworked and is now documented.

## About

##### Why Ubuntu

The following instructions are made for [Ubuntu](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#Ubuntu) / [Debian](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#General) based systems and are not compatible with other operating systems. Ubuntu has been chosen to provide every person with ease of use and stability. Although [Arch Linux](https://wiki.archlinux.org/index.php/Arch_Linux) is just more powerful when it comes to customizability, it is also more difficult to setup, and far easier to accidentally destroy.

Systems not based on Ubuntu, including but not limited to those using package-managers differing from APT or not supporting Snap, are not officially supported by this guide.

##### Knowledge

It is recommended to be familiar with the linux environment and command line. Absolute beginners might start off with a simple Ubuntu installation and become comfortable first, before approaching this.

##### Dependencies

This guide relies on using the following sources.

* [Ubuntu 18.04 LTS](http://releases.ubuntu.com/18.04/) Operating System
* [Alacritty](https://github.com/alacritty/alacritty) Terminal Emulator (main)
* [URXVT](https://wiki.archlinux.org/index.php/Rxvt-unicode) Terminal Emulator (fallback)
* [Aptitude](https://wiki.debian.org/Aptitude) (APT) Packaging Manager
* [Snap](https://wiki.archlinux.org/index.php/Snap) Package Management
* [i3-gaps](https://github.com/Airblader/i3) Tiling Window Manager
* [Xorg](https://wiki.archlinux.org/index.php/Xorg) (X) Display server
* [LightDM](https://wiki.archlinux.org/index.php/LightDM) Display Manager
* [Nemo](https://wiki.archlinux.org/index.php/Nemo) File Manager

## Improvements

##### Desktop Environment and Color Scheme

The i3wm window manager together with the X display server drive your Ubuntu desktop. There is no bloatware or unnecessary waste of screen-space.

The color scheme has been carefully picked and almost all components that can be configured have adapted this theme. Through the use of applications like URXVT and i3, customizability is no problem.

##### Terminal

On first sight, you will realize the prompt / PS1 has changed. It has become clearer and more lightweight. Bash now provides you with many more tools and aliases. The file [`bash_aliases`](resources/bash/.bash_aliases) contains aliases and exported functions. Make yourself familiar with them.

##### Performance and Efficiency

i3 and X are much more lightweight compared to GNOME or KDE. As a result, everything is faster. Through the use of a tiling window manager working with your computer feels easier, as there are pre-defined workspaces.

## Warranty

This guide and these files come with absolutely **no warranty**! The knowledge is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of unleashing indescribable horrors.
