<h1 align="center" >
  <i>i3buntu</i>
</h1>

<p align="center">
    <img src="https://img.shields.io/badge/version-v4.0.0-1A1D23?&style=for-the-badge">
    <img src="https://img.shields.io/badge/stability-stable-FBB444?&style=for-the-badge">
    <br/>
</p>

<h3 align="center" >
  Introduction
</h3>

<p align="center">
  <b><i>i3buntu</i></b> provides means to customize an <a href="https://ubuntu.com/"><i>Ubuntu</i></a> installation by deploying needed programs and sensible default settings. With version 4, we build upon <a href="https://regolith-linux.org/">Regolith Linux</a>. Because of this, the setup has been simplified. Everything you need to know about the installation process can be found in <a href="INSTALL.md"><code>INSTALL.md</code></a>.
</p>

![Desktop Theme](resources/docs/desktop.png)
![Notifications](resources/docs/neovim.png)

<h3 align="center">
  Installation Instructions
</h3>

``` BASH
# obligatory update
sudo apt-get update && sudo apt-get -y upgrade

# start the installation
curl --tlsv1.2 -sSfL https://i3buntu.itbsd.com | bash
```

<h3 align="center" >
  Licensing
</h3>

<p align="center">
  This project is licensed under the <a href="./LICENSE"><i>GNU Lesser General Public License</i></a> version 3.
</p>
