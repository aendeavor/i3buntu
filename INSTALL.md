# Installation

To start off, you will need a Ubuntu ISO image. There are three options really (for a full overview of 18.04 versions see [this link](http://releases.ubuntu.com/18.04/)):

* [Ubuntu 18.04 LTS Desktop](http://releases.ubuntu.com/18.04/ubuntu-18.04.2-desktop-amd64.iso)
* [Ubuntu 18.04 LTS Server](http://releases.ubuntu.com/18.04/ubuntu-18.04.2-live-server-amd64.iso)
* [Ubuntu 18.04 LTS Minimal](https://help.ubuntu.com/community/Installation/MinimalCD)

The first (and worst) of these three choices would also be the easiest. Nevertheless, the desktop version is also the most bloated one and really defeats the purpose of a *minimal* Ubuntu. The second choice, Ubuntu server is in many ways far superior to the desktop version, considering our goal is minimalism. If you want ease of use whilst maintaining a small build, choose the server edition.

The actual best one, and the edition this guide was made for, would be the last, namely the minimal edition. It's bare Ubuntu - or in other words - no bloatware but everything you need to bootstrap your desired system, based on Ubuntu.

That being said, the start can also be the most difficult. As there is no native UEFI support, things can get tricky. But fear not, I've created an ISO image which supports UEFI installation. You can even create your own; everything you need to know is to be found [here](https://github.com/Andevour/Ubuntu-18.04-LTS-Minimal-UEFI-NetInstaller).

The installation process is pretty much straightforward - there are more than enough tutorials in case you need help. If you chose the desktop version, you can struck down certain packages (e.g. *gnome-desktop*), but beware, you will probably end up on the command line. From hereon, if you didn't use the `ks.cfg` to script your installation, the first thing to do would be installing git:

``` sh
sudo apt-get -qq -y update
sudo apt-get -qq -y install git
```

Afterwards, you can clone this repository to your new machine.

``` sh
mkdir minimalUbuntuInstall
cd minimalUbuntuInstall
git clone -- https://github.com/Andevour/i3ubuntu.git .
```

Then execute the `install.sh` script. It will ask you a few questions, which are fairly self-explanatory. If you would like to use Mozilla's official repository, now is the time to add the PPA. if not, just do not execute the first command that now follows.

``` sh
cd scripts
./install.sh
```

The script will install all needed packages and dependencies. Reboot afterwards. If everything went fine, you should be greeted on runlevel 5 by a very ugly LightDM, prompting you to login, as opposed to a command line login. After login, i3 will ask you whether you would like to create an i3 config file. You should answer with yes. Thereafter, i3 will ask you again what *mod* key you would like to use. Choose between *Alt* and *Win* for now - you will be able to change this key later. If you're new to tiling window managers, now would be the time to read a [wiki](https://wiki.archlinux.org/index.php/I3). Open the terminal by pressing *mod+enter*, navigate to this repository and execute the `installCfg.sh`. This script, as opposed to `install.sh`, will configure all config files, from `.Xresources`, over `.bashrc` to `.vimrc`.

``` sh
./installCfg.sh
```

The installCfg-script **will automatically replace** files it is supposed to deploy. It also performs a backup, which can be found in the location you cloned this repository to, under `backups` as `.bak`-files. Log-out and log-in for changes to take effect. i3 can be exited by pressing *mod+shift+e*.


% sudo add-apt-repository -y ppa:git-core/ppa
% sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa
