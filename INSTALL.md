# ![Apollo Logo](athena/resources/theme/apollo_logo.png)

## Installation

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-unstable-FBB444.svg) ![init](https://img.shields.io/badge/init-v0.1.1-2B303B.svg)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.2)

### Instructions

To get things started, get the [_Ubuntu_ Server ISO](https://ubuntu.com/download/server) and install it. Ensure that `wget` and `cmake` are installed. `rsync` ought to work too. It is recommended to update your system beforehand.

``` BASH
# obligatory
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# mandatory
sudo apt-get install -y wget cmake
```

You can now go ahead and start ***APOLLO***.

``` BASH
curl -L --proto '=https' --tlsv1.2 -sSf apollo.itbsd.com | bash
```

### Miscellaneous

#### Prerequisites & Manual Start

It is recommended to be familiar with a Linux environment and the command line. Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA512 sum is `005605de16977627954b5445f7fa7eec6f4f040a7b427b4c947f432e6f450ade6b58498b4390dfb92db3a57e0f9a48d608cdcb0661b9f8320d0b9d0f9ac8738c  init.sh`

#### Leftover Configuration

As of now, the monitor/display configuration is not done automatically, as this would not make much sense. You can do it manually, with `arandr` and `i3`'s config.

#### Miscellaneous Scripts

Found under `athena/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. This includes [`exa`](https://the.exa.website/), [`i3-rounded-corners`](https://github.com/terroo/i3-radius) and a fonts installer.
