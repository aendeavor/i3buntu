# Installation

![init][init]

1. [Instructions](#instructions)
2. [Handcrafted Finish](#handcrafted-finish)
3. [Miscellaneous](#miscellaneous)
   1. [Integrity](#integrity)
   2. [Other Scripts](#other-scripts)
   3. [GDM3 vs LightDM](#gdm3-vs-lightdm)

## Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO][iso] and install it. To start the installation process, use

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start the installation
curl --tlsv1.2 -sSfL i3buntu.itbsd.com | bash
```

When executing the application manually, do **not** start it in a root / superuser context. Either use `./i3buntu` or `make install`.

## Handcrafted Finish

The monitor/display configuration is not done automatically as this wouldn't make sense. You can do it manually with `arandr` and `i3`'s config.

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, we will need to build some packages from source. All dependencies have already been installed. What is left to do is executing `i3rdp.sh` in the `library/scripts/` directory.

Thereafter, edit i3's config under `~/.config/i3/config` to use Picom and not Compton. At the bottom, the autostart applications can be edited - adjust them. You can also play with Picom's configuration located under `~/.config/picom.conf`. Delete the old config under `~/.config/compton.conf`

### Miscellaneous

#### Integrity

The `init.sh` is checked with `SHA512`, `SHA256` and `SHA1` sums to verify integrity.

#### Other Scripts

Found under `library/scripts/`, a few scripts reside there to ease the pain of installing certain software by hand. These include [`exa`][exa] or [`ycm`][ycm].

#### GDM3 vs LightDM

We install [LightDM][lightdm] as an alternative to [GDM3][gdm3]. When you have [GDM3][gdm3] installed and do not wish to remove it, you need to press "Return" when a package installs LightDM directly or as a dependency. If you don't, the process will just not continue.

[//]: # (Links)

[init]: https://img.shields.io/badge/init-v0.4.1-2B303B?&style=for-the-badge

[iso]: https://ubuntu.com/download/server
[exa]: https://the.exa.website/
[ycm]: https://github.com/ycm-core/YouCompleteM
[lightdm]: https://wiki.ubuntuusers.de/LightDM/
[gdm3]: https://wiki.ubuntuusers.de/GDM/
