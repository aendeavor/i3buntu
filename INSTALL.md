# ![Apollo Logo](athena/docs/apollo_logo.png)

## Installation

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-stable-FBB444.svg) ![init](https://img.shields.io/badge/init-v0.2.0-2B303B.svg)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.6)

### Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO](https://ubuntu.com/download/server) and install it. ***APOLLO*** depends on `curl`, `wget` and `rsync`, all of which are already installed. To start ***APOLLO***, use

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

- SHA512 sum `e45c61044ceb5f85c4f8710f5941b6b30748b282fa6d57dd38e2836a8026a2bf7dd6ff18aa607a4f98fff9bcb90aabf96ad2d1212571811d91cbff81e70e99e4  init.sh`
- SHA1 sum `512dfc4eb37d39b25d9cfadc90be003d096d1d9c  init.sh`

#### Scripts

Found under `athena/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. These include [`exa`](https://the.exa.website/) or [`ycm`](https://github.com/ycm-core/YouCompleteMe).

#### GDM3 vs LightDM

***APOLLO*** installs [LightDM](https://wiki.ubuntuusers.de/LightDM/) as an alternative to [GDM3](https://wiki.ubuntuusers.de/GDM/). When you have GDM3 installed and do not wish to remove it, you need to press "Return" when a package installs LightDM directly or as a dependency. If you don't, the process will just not continue.
