# ![Apollo Logo](athena/style/apollo_logo.png)

## Installation

[![stability](https://img.shields.io/badge/stability-unstable-red.svg)](https://shields.io/) [![init](https://img.shields.io/badge/init-0.1.0-yellow.svg)](https://shields.io/) [![apollo main](https://img.shields.io/badge/apollo_main-0.1.0-yellow.svg)](https://shields.io/) 

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.0)

### Operating System

To get things started, get the [_Ubuntu_ Server ISO](https://ubuntu.com/download/server) and install it. It supports [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) right out of the box.

### Starting _APOLLO_

Update your system and ensure that `wget`, `cmake` and `unzip` are installed

``` BASH
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

sudo apt-get install -y wget unzip cmake
```

You can now go ahead and start ***APOLLO***

``` BASH
curl -L --proto '=https' --tlsv1.2 -sSf apollo.itbsd.com | bash
```

#### Miscellaneous

##### Prerequisites

It is recommended to be familiar with the Linux environment, the command line and to have a basic knowledge about the file system structure. When working with administrator privileges, you ought to know what you are doing.

##### Manual Start

Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

##### Security

If you are concerned about security, you may be reliefed to hear we are using HTTPS and TLSv1.2 in an end-to-end encryption to obtain `init.sh`. If you are still uncomfortable piping `curl` into `bash`, just download the script with curl, check it and execute it later.

##### Leftover Configuration

Sometimes, it's easier to configure a few settings on your own. These include:

- Monitor Setup / Resolution

[//]: # (TODO state installation process)
