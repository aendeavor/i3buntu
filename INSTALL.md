# ![Apollo Logo](athena/docs/apollo_logo.png)

## Installation

![version][version] ![stability][stability] ![init]

1. [Instructions](#instructions)
2. [Leftover Configuration](#leftover-configuration)
3. [Handcrafted Finish](#handcrafted-finish)
4. [Miscellaneous](#miscellaneous)
   1. [Security](#scripts)
   2. [Scripts](#scripts)
   3. [GDM3 vs LightDM](#gdm3-vs-lightdm)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.6)

### Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO][iso] and install it. ***APOLLO*** depends on `curl`, `wget` and `rsync`, all of which are already installed. To start ***APOLLO***, use

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start APOLLO
curl --tlsv1.2 -sSfL https://apollo.itbsd.com | bash
```

When executing ***APOLLO*** manually, do **not** start it in a root / superuser context. Either use `./apollo` or `make install`.

#### Leftover Configuration

As of now, the monitor/display configuration is not done automatically, as this would not make much sense. You can do it manually, with `arandr` and `i3`'s config.

#### Handcrafted Finish

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, we will need to build some packages from source. All dependencies have already been installed. What is left to do is executing `i3rdp.sh` in the `athena/scripts/` directory.

Thereafter, edit i3's config under `~/.config/i3/config` to use Picom and not Compton. At the bottom, the autostart applications can be edited - adjust them. You can also play with Picom's configuration located under `~/.config/picom.conf`.

### Miscellaneous

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA sums are

- SHA512
  `65fb9fee3327ea298d7f0b080fe8ba144d78b87b1f33e87b7d3e2607c127021221bd28c6bad611716ab989174ef3d5c00962216b185c3243a8c73cd65eeb5eed  init.sh`
- SHA256
  `b0884fd312b287f63daefff60bef488811e97d039c20961c15d6444145272945  init.sh`
- SHA1
  `87df13f3c59a6a287067211a65efe8bddf668b34  init.sh`

#### Scripts

Found under `athena/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. These include [`exa`][exa] or [`ycm`][ycm].

#### GDM3 vs LightDM

***APOLLO*** installs [LightDM][lightdm] as an alternative to [GDM3][gdm3]. When you have GDM3 installed and do not wish to remove it, you need to press "Return" when a package installs LightDM directly or as a dependency. If you don't, the process will just not continue.

[//]: # (Links)

[version]: https://img.shields.io/badge/version-v2.1.0-1A1D23.svg
[stability]: https://img.shields.io/badge/stability-stable-FBB444.svg
[init]: https://img.shields.io/badge/init-v0.2.2-2B303B.svg
[iso]: https://ubuntu.com/download/server
[exa]: https://the.exa.website/
[ycm]: https://github.com/ycm-core/YouCompleteM
[lightdm]: https://wiki.ubuntuusers.de/LightDM/
[gdm3]: https://wiki.ubuntuusers.de/GDM/
