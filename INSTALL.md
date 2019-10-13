# Installation

## Runlevel 0 - Acquiring an ISO

#### Ubuntu 18.04.3 LTS Desktop & Server

To get things started, you will need an Ubuntu ISO image. As of now, the latest LTS (Long Term Support) version is 18.04.3 - the images for the desktop and server variant are found [here](http://releases.ubuntu.com/18.04/). The installation of these is straightforward as there is little to no difference between both versions. Just remove GNOME after you installed the desktop image and you are good to go. 

These images support [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) right out of the box.

#### Ubuntu 18.04 LTS Minimal

There is another option when it comes to choosing an Ubuntu flavour. There is a [minimal image](https://help.ubuntu.com/community/Installation/MinimalCD), containing only absolutely neccessary packages. If you like it lean, chose this variant, but be aware that you will likely need to get some packages and dependencies yourself - this installation is going to be more difficult, as it becomes some sort of bootstrapping.

This image does not support UEFI right out of the box. However, I created an ISO for you, which can be found [here](https://github.com/Andevour/Ubuntu-18.04-LTS-Minimal-UEFI-NetInstaller). You can even create your own - just follow the instructions on this very page.

## Runlevel 3 - Managing packages

If you chose the desktop version, struck down GNOME packages, e.g. `gnome-desktop*` and reboot. From hereon, if you didn't use the `ks.cfg` (see link to minimal installation) to script your installation, the first thing to do would be installing git:

``` BASH
# update to the latest state, if possible
sudo apt-get -y update && sudo apt-get -y upgrade

# get neccessary tools to add an APT repository
apt-get install -y software-properties-common python-software-properties

# add official GIT-Core and Mozilla APT repositories
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:ubuntu-mozilla-security/ppa

# install GIT itself
sudo apt-get install git
```

Afterwards, you can clone this repository to your new machine. Then execute the `packaging.sh` script. The script will install all needed packages and dependencies, it will let you make some choices and it will reboot your computer after everything is finished.

``` BASH
# clone this repository into the folder i3buntu
cd && git clone -- https://github.com/Andevour/i3ubuntu.git .

# execute the primary packaging script
./i3buntu/scripts/packaging.sh
```

## Runlevel 5 - Configuration

If everything went fine, you should be greeted on a graphical interface. After login, i3 will ask you whether you would like to create an i3 config file, which you will answer with *yes*. For your *mod key*, choose the *Win* key. If you're new to tiling window managers, now would be the time to read a [wiki](https://wiki.archlinux.org/index.php/I3).

Open the terminal by pressing *mod+enter* and execute the configuration script. It will setup all config files, from `.Xresources` over `.bashrc` to `.vimrc`. The [`configuration.sh`](./scripts/configuration.sh)-script **will automatically replace** files which it is supposed to deploy. It also performs a backup which can be found in `~/i3buntu/backups/` containing `.bak`-files and it will reboot your computer.

``` BASH
cd && ./scripts/configuration.sh
```

## Runlevel ∞ - Tweaks

You may need to tweak Xorg to output your screens correctly, in case you have more than one monitor. The config file can be found under `/etc/X11/xorg.conf`. The programm *arandr* will assist you with the setup of multiple monitors. Also, although unlikely, make sure to install a graphics driver, if none has been installed.

As all functionality has been setup, open *LXappearance* by pressing *Win + d*. *rofi* will be opened and will let you choose an application. Just type in "lxa..." and it should be there, hit return to open it. Choose your color theme, icon pack and font.
