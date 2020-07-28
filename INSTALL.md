# ![Apollo Logo](athena/resources/theme/apollo_logo.png)

## Installation

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-unstable-FBB444.svg) ![init](https://img.shields.io/badge/init-v0.1.1-2B303B.svg)

[//]: # (Explains the installation process of APOLLO)
[//]: # (version 0.1.2)

### Instructions

To get things started, get the [_Ubuntu_ Server ISO](https://ubuntu.com/download/server) and install it. Ensure that `wget`, `cmake`, `rsync` and `unzip` are installed; they should already be installed. It is recommended to update your system beforehand.

``` BASH
# obligatory
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# mandatory
sudo apt-get install -y wget rsync unzip cmake
```

You can now go ahead and start ***APOLLO***.

``` BASH
curl -L --proto '=https' --tlsv1.2 -sSf apollo.itbsd.com | bash
```

### Miscellaneous

#### Prerequisites & Manual Start

It is recommended to be familiar with a Linux environment and the command line. Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA512 sum is `6fddfe348758784058d1c42f3258b95faa37fc0fefdeb0e081bc03118c6aaff4a16748bbe4e507e6a8f96c81f323662d81c0c40cd0f1853de79e7fed3519a223  init.sh`
 
#### Leftover Configuration

As of now, the monitor configuration is not done automatically, as this would not make much sense. You can do it manually, with `arandr` and `i3`'s config.
