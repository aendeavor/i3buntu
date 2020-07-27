# ![Apollo Logo](athena/style/apollo_logo.png)

## Installation

[![stability](https://img.shields.io/badge/stability-unstable-red.svg)](https://shields.io/) [![init](https://img.shields.io/badge/init-0.1.1-yellow.svg)](https://shields.io/) [![apollo main](https://img.shields.io/badge/apollo_main-0.1.0-yellow.svg)](https://shields.io/) 

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.2)

### Instructions

To get things started, get the [_Ubuntu_ Server ISO](https://ubuntu.com/download/server) and install it. It supports [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) right out of the box.

Ensure that `wget`, `cmake` and `unzip` are installed. It is recommended to update your system beforehand.

``` BASH
# obligatory
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# mandatory
sudo apt-get install -y wget unzip cmake
```

You can now go ahead and start ***APOLLO***.

``` BASH
curl -L --proto '=https' --tlsv1.2 -sSf apollo.itbsd.com | bash
```

### Miscellaneous

#### Prerequisites & Manual Start

It is recommended to be familiar with a Linux environment and the command line. Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA512 sum is `daae7a7fe37e841ad6360af829cfedbcbe1ed52fe3c4a737eeb346397768230a98304083de3be31a7168887e5d1eb05b8458e0a79aea48644f71e5ddd1b084ac  init.sh`

#### Leftover Configuration

As of now, the monitor configuration is not done automatically, as this would not make much sense. You can do it manually, with `arandr` and `i3`'s config.
