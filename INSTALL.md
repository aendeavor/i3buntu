# Installation

![version][version] ![stability][stability] ![init][init]

1. [Instructions](#instructions)
2. [Handcrafted Finish](#handcrafted-finish)
3. [Miscellaneous](#miscellaneous)
   1. [Security](#scripts)
   2. [Scripts](#scripts)
   3. [GDM3 vs LightDM](#gdm3-vs-lightdm)

## Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO][iso] and install it. The application depends on `curl`, `wget` and `rsync`, all of which are already installed. To start the process, use

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start the installation
curl --tlsv1.2 -sSfL https://i3buntu.itbsd.com | bash
```

When executing the application manually, do **not** start it in a root / superuser context. Either use `./i3buntu` or `make install`.

## Handcrafted Finish

The monitor/display configuration is not done automatically as this wouldn't make sense. You can do it manually with `arandr` and `i3`'s config.

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, we will need to build some packages from source. All dependencies have already been installed. What is left to do is executing `i3rdp.sh` in the `library/scripts/` directory.

Thereafter, edit i3's config under `~/.config/i3/config` to use Picom and not Compton. At the bottom, the autostart applications can be edited - adjust them. You can also play with Picom's configuration located under `~/.config/picom.conf`. Delete the old config under `~/.config/compton.conf`

### Miscellaneous

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA sums are

- SHA512 `ea452e3337024390e630587e83b0e63174d67f410c7a5db1ec6bdbd564af03698f2ef018804aafe41576123dda6f66b136834e28fcc1d7a55de7683d7ad99a29  init.sh`
- SHA256 `0a6de54606ed269c5bcab9b7076db21289f801e1145241a1a37d61a2739c1d3c  init.sh`
- SHA1 `3c5e916666822738d04d540c0e72aedc8b9eb087  init.sh`

#### Scripts

Found under `library/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. These include [`exa`][exa] or [`ycm`][ycm].

#### GDM3 vs LightDM

We install [LightDM][lightdm] as an alternative to [GDM3][gdm3]. When you have [GDM3][gdm3] installed and do not wish to remove it, you need to press "Return" when a package installs LightDM directly or as a dependency. If you don't, the process will just not continue.

[//]: # (Links)

[version]: https://img.shields.io/badge/version-v3.0.0-1A1D23?&style=for-the-badge
[stability]: https://img.shields.io/badge/stability-stable-FBB444?&style=for-the-badge

[init]: https://img.shields.io/badge/init-v0.3.0-2B303B?&style=for-the-badge
[iso]: https://ubuntu.com/download/server
[exa]: https://the.exa.website/
[ycm]: https://github.com/ycm-core/YouCompleteM
[lightdm]: https://wiki.ubuntuusers.de/LightDM/
[gdm3]: https://wiki.ubuntuusers.de/GDM/
