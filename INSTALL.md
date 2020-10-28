# ![Apollo Logo](library/docs/apollo_logo.png)

## Installation

![version][version] ![stability][stability] ![init][init]

1. [Instructions](#instructions)
2. [Handcrafted Finish](#handcrafted-finish)
3. [Miscellaneous](#miscellaneous)
   1. [Security](#scripts)
   2. [Scripts](#scripts)
   3. [GDM3 vs LightDM](#gdm3-vs-lightdm)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.6)

### Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO][iso] and install it. The application depends on `curl`, `wget` and `rsync`, all of which are already installed. To start the process, use

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start APOLLO
curl --tlsv1.2 -sSfL https://apollo.itbsd.com | bash
```

When executing the application manually, do **not** start it in a root / superuser context. Either use `./apollo` or `make install`.

### Handcrafted Finish

The monitor/display configuration is not done automatically as this wouldn't make sense. You can do it manually with `arandr` and `i3`'s config.

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, we will need to build some packages from source. All dependencies have already been installed. What is left to do is executing `i3rdp.sh` in the `library/scripts/` directory.

Thereafter, edit i3's config under `~/.config/i3/config` to use Picom and not Compton. At the bottom, the autostart applications can be edited - adjust them. You can also play with Picom's configuration located under `~/.config/picom.conf`. Delete the old config under `~/.config/compton.conf`

### Miscellaneous

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA sums are

- SHA512 `b0687fd13a4fe811458a51c06a1bb26b8174f894dd08572714ed60061f575e01a26fef86621e5f02ef95fdca48272fc11d82d73d024f7bee6068b8603333ad6f  init.sh`
- SHA256 `d6d512d99075c239f7c0212ded414cfcc9ac218faf448ea0db80a266a9668f3c  init.sh`
- SHA1 `633800bdf738d954893948d7b663efd6f80c4784  init.sh`

#### Scripts

Found under `library/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. These include [`exa`][exa] or [`ycm`][ycm].

#### GDM3 vs LightDM

We install [LightDM][lightdm] as an alternative to [GDM3][gdm3]. When you have [GDM3][gdm3] installed and do not wish to remove it, you need to press "Return" when a package installs LightDM directly or as a dependency. If you don't, the process will just not continue.

[//]: # (Links)

[version]: https://img.shields.io/badge/version-v2.3.1-1A1D23?&style=for-the-badge
[stability]: https://img.shields.io/badge/stability-stable-FBB444?&style=for-the-badge

[init]: https://img.shields.io/badge/init-v0.2.2-2B303B?&style=for-the-badge
[iso]: https://ubuntu.com/download/server
[exa]: https://the.exa.website/
[ycm]: https://github.com/ycm-core/YouCompleteM
[lightdm]: https://wiki.ubuntuusers.de/LightDM/
[gdm3]: https://wiki.ubuntuusers.de/GDM/
