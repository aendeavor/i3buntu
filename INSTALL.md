# Installation

[//]: # (Explains the installation process of i3buntu)
[//]: # (version 0.9.3)

## Runlevel 0 - Acquiring an ISO

#### Ubuntu 18.04.3 LTS Desktop & Server

To get things started, you will need an Ubuntu ISO image. As of now, the latest LTS (Long Term Support) version of Ubuntu is 18.04.3 - the images for the desktop and server variant are found [here](http://releases.ubuntu.com/18.04/). The installation of these is straightforward as there is little to no difference between both versions. These images also support [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) right out of the box. You can then remove GNOME after you installed the desktop image and you are good to go.

#### Ubuntu 18.04 LTS Minimal

There is another option when it comes to choosing an Ubuntu flavour. There is a [minimal image](https://help.ubuntu.com/community/Installation/MinimalCD), containing only absolutely necessary packages. If you like it lean, chose this variant, but be aware that you will likely need to get some packages and dependencies yourself - this installation is going to be more difficult, as it becomes some sort of bootstrapping.

This image does not support UEFI right out of the box. However, I created an ISO for you, which can be found [here](https://github.com/aendeavour/Ubuntu-18.04-LTS-Minimal-UEFI-NetInstaller). You can even create your own - just follow the instructions on this very page.

## Runlevel 3 - Managing packages

If you chose the desktop version, you can remove GNOME packages, e.g. `gnome-desktop*` and reboot. This is, however, not an absolute must, as some might prefer to have an alternative to i3. From hereon, update and grab mandatory ppa-repositories:

``` BASH
# update to the latest state, if possible
sudo apt-get -y update && sudo apt-get -y upgrade

# get necessary tools to add an APT repository
sudo apt-get install -y software-properties-common

# add official GIT-Core and Mozilla APT repositories
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:ubuntu-mozilla-security/ppa
```

Afterwards, download a release of i3buntu onto your system. You will need to extract  it, and, if you like, you can rename it. The following commands accomplish just that.

``` BASH
# download the latest stable release
cd && wget https://github.com/aendeavor/i3buntu/archive/v0.8.1-stable.tar.gz

# or grab the latest unstable release
cd && wget https://github.com/aendeavor/i3buntu/archive/v0.9.2-beta.3.tar.gz

# decompress the .tar.gz
tar xvfz v0.8.1-stable.tar.gz && rm v0.8.1-stable.tar.gz

# rename the directory
mv i3buntu* i3buntu
```

_Before version v0.9.2-beta1_, you will need to execute the `packaging.sh` script. The script will install all needed packages and dependencies, it will let you make some choices and it will reboot your computer after everything is finished. If you are using a newer version, skip the next command and read on.

``` BASH
# version 0.8.1-stable and before - execute the packaging.sh script
cd && ./i3buntu/scripts/packaging.sh
```

_From version v0.9.2-beta1 onwards_ however, there is a new and enhanced way. In the root of the i3buntu directory, right where this file is located, there is the new [`install.sh`](./install.sh) script. With this new script, you are able to install not only the desktop, but also a server version (mainly without graphical environment) or you can create a Docker container. This is how you use it:

``` BASH
# For desktop installations, you will need
# to execute the packaging and configuration separately.
cd && ./i3buntu/install.sh desktop --pkg

# You can also omit pkg - you will then be
# prompted whether you want packaging or configuration to happen.
cd && ./i3buntu/install.sh desktop

# For server installations, run
cd && ./i3buntu/install.sh server

# To create and run a Docker container, run
cd && ./i3buntu/install.sh docker
```

## Runlevel 5 - Configuration

After a reboot, you should be greeted on a graphical interface. During login, i3 will ask you whether you would like to create an i3 config file, which you will answer with _yes_. For your _mod key_, choose the _Super_ key. If you're new to tiling window managers, now would be the time to read a [wiki](https://wiki.archlinux.org/index.php/I3).

Before you go though, make sure to put in the correct xrandr/arandr settings. You will need to do this to make sure your screens are properly displayed. As each screen setup is different, there is no universal automated solution here. Just open `arandr`, either by command line or through rofi, which is invoked with _mod + d_. `arandr` will assist you with the setup of multiple monitors. When you are done and satisfied, save these setting in a file of your choice, open this file and copy the content. Next, open i3's `config`-file in this repository

``` BASH
cd ~/i3buntu && vi ./resources/sys/Xi3/config
```

Paste your setup in these lines

![xrandr settings](resources/doc/xrandr_settings.png)

Afterwards, save the file and run your configuration script

_Before version v0.9.2-beta1_, you will need to execute the `configuration.sh` script. Open the terminal by pressing _mod + Enter_ and execute it. It will setup all configuration-files and **will automatically replace** files which it is supposed to deploy. It also performs a backup which can be found in `~/i3buntu/backups/` containing `.bak`-files.

``` BASH
cd && ./i3buntu/scripts/configuration.sh
```

_From version v0.9.2-beta1 onwards_ however, [`install.sh`](./install.sh) also grants you the ability to configure i3buntu with necessary configuration files. It basically works just like the old `configuration.sh` with enhancements. A backup is performed, files are replaced, user-choices processed. The server-installation does this automatically, so you will not need to do this yourself if you install i3buntu as a server. There is also no separate configuration for the Docker container. This is how you invoke configuration:

``` BASH
# For desktop installations, you will need
# to execute the packaging and configuration separately.
cd && ./i3buntu/install.sh desktop --cfg

# You can also omit cfg - you will then be
# prompted whether you want packaging or configuration to happen.
cd && ./i3buntu/install.sh desktop
```

## Runlevel ∞ - Tweaks

That's it. You may need to tweak Xorg (the config file can be found under `/etc/X11/xorg.conf`). Also, although unlikely, make sure to install the correct graphics driver, if none has been installed.

As all functionality has been setup, open *LXappearance* by pressing _mod + d_. _Rofi_ will let you choose an application. Just type in 'lxappearance' and it should be there (you may need to hit return to open it). Choose your color theme, icon pack and font.
