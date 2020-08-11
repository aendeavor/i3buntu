# ![Apollo Logo](athena/docs/apollo_logo.png)

## Installation

![version](https://img.shields.io/badge/version-v2.0.0-1A1D23.svg) ![stability](https://img.shields.io/badge/stability-unstable-FBB444.svg) ![init](https://img.shields.io/badge/init-v0.1.4-2B303B.svg)

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

As _Ubuntu 20.04 LTS_ only ships a stable package upstream, the latest and greatest details ought to be done by hand. You will need to get [_Picom_](https://github.com/ibhagwan/picom) by hand, grab the latest stable release and build it from source. The dependencies should have already been installed.

[//]: # (The same goes for [_Dunst_](https://github.com/dunst-project/dunst). Make sure to remove the packages first.)

For rounded corners, you will need to build [_i3-radius_](https://github.com/terroo/i3-radius). Like Picom and Dunst, build it from source. Under Ubuntu 20.04 you may need to grab the build dependencies. You can get them with `sudo apt-get build-dep <package>` or `sudo apt-get install -f`.

Head over to i3's config in `~/.config/i3/config` and uncomment `border-radius`. Next, navigate to the bottom and remove the `exec compton &`, and uncomment the line which starts with `exec picom <...>`.

### Miscellaneous

#### Prerequisites & Manual Start

It is recommended to be familiar with a Linux environment and the command line. Before the actual program start, you may choose to stop the installation. You can start it manually with `make install`.

#### Security

If you are concerned about piping `curl` into `bash`, just download the script with curl, check and execute it later. The SHA512 sum is `005605de16977627954b5445f7fa7eec6f4f040a7b427b4c947f432e6f450ade6b58498b4390dfb92db3a57e0f9a48d608cdcb0661b9f8320d0b9d0f9ac8738c  init.sh`.

#### Miscellaneous Scripts

Found under `athena/scripts/`, a few leftover script reside to ease the pain of installing certain software by hand. This includes [`exa`](https://the.exa.website/), [`i3-rounded-corners`](https://github.com/terroo/i3-radius) and a fonts installer.
