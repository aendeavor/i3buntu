# Ubuntu minimal & i3

## Disclaimer

The repository is under construction. Most of the instructions are present and correct, but they lack implementation on code-level. This can be seen under versions down below.

## Preamble

This repository aims at providing you with a set of instructions to create your own minimal Ubuntu installation with the i3 window manager. This will enable you to not only work more efficiently with your system, but also in a much more beautiful environment. All important keywords are marked with hyperlinks so you can click on them. Before you start though, make sure you meet the prerequisities!

## Prerequisites

### Why bother

![Desktop Theme](resources/others/desktopTheme.png)

[And because of this.](https://www.reddit.com/r/unixporn/)

### Why Ubuntu

The following instructions are made for [Ubuntu](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#Ubuntu) / [Debian](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions#General) based systems and are not compatible with are operating systems. Even if Ubuntu minimal is not what you are looking for, there still might be a chance of you learning something in case you read further.

Ubuntu has been chosen to provide every person with ease of use and stability. Although [Arch Linux](https://wiki.archlinux.org/index.php/Arch_Linux) is just more powerful when it comes to customizability, and also features [Pacman](https://wiki.archlinux.org/index.php/Pacman) and the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository), it is also more difficult to setup, and far easier to accidentally destroy. That being sad, if you're planning to use Arch, go ahead - there is in no way a restriction, but, here is the disclaimer:

**Systems not based on Ubuntu, including those using package-managers differing from APT or not supporting Snap, are not (officially) supported by this guide.**

### Knowledge

It is highly recomended to be familier with the linux environment and command line. Absolute beginners might start off with a simple Ubuntu installation and become comfortable with those first, before approaching this. You needn't be an absolute professional, but at least have some notion of linux.

### Preconfig

Preconfiguration is being done on a linux machine. Everything that is or will be mentioned in this article can be done on a linux machine.

### Dependencies

This guide relies on using the following sources:

* [Ubuntu 18.04 LTS Minimal](https://help.ubuntu.com/community/Installation/MinimalCD)
* [URXVT](https://wiki.archlinux.org/index.php/Rxvt-unicode) Terminal Emulator
* [Aptitude](https://wiki.debian.org/Aptitude) (APT) Packaging Manager
* [Snap](https://wiki.archlinux.org/index.php/Snap) Package Management
* [i3](https://wiki.archlinux.org/index.php/I3)-gaps Tiling Window Manager
* [Xorg](https://wiki.archlinux.org/index.php/Xorg) (X) Display server
* [LightDM](https://wiki.archlinux.org/index.php/LightDM) Display Manager
* [Mesa](https://en.wikipedia.org/wiki/Mesa_%28computer_graphics%29) Graphics API
* [Nemo](https://wiki.archlinux.org/index.php/Nemo) File Manager

## Install instructions

Are found [here](./INSTALL.md).

## Versions - alpha v0.3.3

The most important files are currently found in the following versions:

| filename                   | version                    | stable                 |
|:--------------------------:|:--------------------------:|:----------------------:|
| i3                         | 0.5.1                      | no                     |
| URXVT                      | 0.4.6                      | no                     |
| bashrc                     | 0.3.7                      | yes                    |
| bash_aliases               | 0.4.1                      | no                     |
| Xresources                 | 0.5.2                      | no                     |
| VIM                        | 0.3.8                      | yes                    |
| installCfg                 | 0.4.9                      | yes                    |
| install                    | 0.4.4                      | yes                    |
| README                     | 0.8.6                      | rock-solid             |
| INSTALL                    | 0.3.5                      | adamantine             |

## Improvements

### Functionality

#### i3

Most notably, the i3 window manager is what will set you apart. After a short amount of time, you will get used to tiling and wish never to never use another wm again. i3 speaks for itself, so there is no great explanation needed here.

#### Bash

Bash now provides you with many more tools and shortcuts (aliases). You might want to look the up. The file `bash_aliases` in `resources/bash/` contains, obviously, the aliases and exported functions. Make youself familiar with them. If you would like to add some, feel free to add the bash_aliases yourself. The moment you run `installCfg.sh` again, the script will deploy your new aliases and functions. Just be sure to open a new terminal before you try them. Notable functions are `update`, which will update all your APT and snap packages, `sf` searches for files and directories on the same level. You will be able to auto-cd into directories - just type in their names and press enter.

On first sight, you will realize the prompt / PS1 has changed. It has become clearer, and more lightweight.

#### VIM

VIM *should* now be your default editor. There are numerous options enabled, to customize VIM to be more friendly and more efficient. You will be able to set them yourself, of course. The file you are looking for is `.vimrc` under `resources/vim`.

### Design

#### Desktop

Custom i3-gaps is just different, and will not only set you apart when it comes to functionality, but also when it comes to looks.

#### Terminal

The terminal emulator URXVT is plain simple, and customizable. It has been preconfigured, but `.Xresources` keeps all settings you want if you need to change some things up. Feel free!

#### Color scheme

The color scheme has been carefully picked and almost all components that can be configured have adapted this theme. Through the use of applications like URXVT and i3, customizability is no problem. If you are not satisfied with colors, change them up on your own.

#### Lockscreen

i3-lock can be your lockscreen of choice. Just have a [look at it](https://raw.githubusercontent.com/meskarune/i3lock-fancy/master/screenshot.png).

## Warranty

This guide and these files come with absolutely **no warranty**!
