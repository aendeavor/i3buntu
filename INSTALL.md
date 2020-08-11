# ![Apollo Logo](athena/docs/apollo_logo.png)

## Installation

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-unstable-FBB444.svg) ![init](https://img.shields.io/badge/init-v0.1.6-2B303B.svg)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.4)

### Instructions

To get things started, get the [_Ubuntu 20.04 LTS_ Server ISO](https://ubuntu.com/download/server) and install it. ***APOLLO*** depends on `curl`, `wget` and `rsync`, all of which are already be installed. To start ***APOLLO***, use

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start APOLLO
curl --tlsv1.2 -sSfL https://apollo.itbsd.com | bash
```

#### Leftover Configuration

As of now, the monitor/display configuration is not done automatically, as this would not make much sense. You can do it manually, with `arandr` and `i3`'s config.

#### Handcrafted Finish

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, we will need to build some packages from source. All dependencies have already been installed. All that is left to do is executing `i3rdp.sh` in the `athena/scripts/` directory.

### Miscellaneous

#### Prerequisites & Manual Start

It is recommended to be familiar with a Linux environment and the command line. Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA512 sum is
`4c0938af0968571c6714c892fa74424a41e2b0f6a63ba6503faccf8d50e6b9289906236ccef364353a1a6359db5e1f09dcbf5b66532d8d92fddb28ca63d4fad2  init.sh`.

#### Scripts

Found under `athena/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. These include [`exa`](https://the.exa.website/) or [`ycm`](https://github.com/ycm-core/YouCompleteMe).

#### GDM3 vs LightDM

***APOLLO*** installs [LightDM](https://wiki.ubuntuusers.de/LightDM/) as an alternative to [GDM3](https://wiki.ubuntuusers.de/GDM/). When you have GDM3 installed and do not wish to remove it, you need to press "Return" when a package install LightDM directly or as a dependency. If you don't, the process will just not continue.
