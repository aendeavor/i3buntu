# Installation

[//]: # (Explains the installation process of i3buntu)
[//]: # (version 1.0.13)

## Runlevel 0 - Installing the operating system

To get things started, you will need an [Ubuntu ISO image](https://ubuntu.com/download). As of now, the latest LTS (Long Term Support) version of Ubuntu is 20.04. The installation is straightforward. **We recommend using the server version** as it ships without unnecessary packages. These images also support [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) right out of the box.

## Runlevel 3 - Managing packages

If you chose the desktop version, you can remove GNOME packages and reboot. This is, however, not an absolute must, as some might prefer to have an alternative to _i3-gaps_. From hereon, update the system. Afterwards, just execute the `curl` command. It will setup everything you need. Keep in mind: For server installations, this step will finish _i3buntu_'s installation. For desktops, you will need to start configuration separately.

``` BASH
# (Optional) Remove GNOME
sudo apt-get purge gnome-desktop*

# (Optional) Update the system and install curl
sudo apt-get -y update && sudo apt-get -y dist-upgrade
sudo apt-get install curl

# Execute the bootstrap script
curl \
  --proto '=https'\
  --tlsv1.2\
  -sSf\
  https://raw.githubusercontent.com/aendeavor/i3buntu/development/resources/scripts/i3buntu_init.sh | bash
```

The `curl` command will create an i3buntu directory and execute the [install.sh](./install.sh) script. If you would like to start an installation manually, you can do so:

``` BASH
# For desktop installations, you will need
# to execute the packaging and configuration separately
./i3buntu/install.sh desktop --pkg

# For server installations, run
./i3buntu/install.sh server
```

## Runlevel 5 - Configuration

On desktops, you should be greeted on a graphical interface after a reboot. During login, i3 will ask you whether you would like to create an i3 config file, which you will answer with yes. For your _mod key_, choose the _Super_ key.

You will now need to create the fitting _xrander_ settings so your screens are displayed the way they should. Open `arandr`, either by command line or through rofi, which is invoked with _mod + d_. `arandr` will assist you with the setup of multiple monitors. When you are done, save these setting in a file of your choice, open this file and copy the content. Next, open i3's `config`-file in this repository on the command line wit _mod + Return_

``` BASH
cd i3buntu && vi resources/sys/Xi3/config
```

and paste your setup in these lines after `exec_always xrander`

![xrandr settings](resources/doc/xrandr_settings.png)

Afterwards, save the file and run your configuration script. The server-installation does this automatically, so you will not need to do this yourself if you install _i3buntu_ as a server. This is how you invoke configuration:

``` BASH
cd && ./i3buntu/install.sh desktop --cfg
```

## Runlevel ∞ - Icon and color theme

Now, just use _LXappearance_ to mod your color theme (Adapta Blue Nokto Eta) and your icon theme (Tela Black Dark) - open rofi with _mod + d_ and start typing the name of the desired application and hit enter. If you like, edit `~/.config/i3/config` to customize your keybindings and to edit the pactl binds if audio volume control will not work.

That's it.
