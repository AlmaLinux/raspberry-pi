# AlmaLinux Official Raspberry Pi Image

[![asciicast](https://asciinema.org/a/423618.svg)](https://asciinema.org/a/423618)

Last Update 2021-11-12: [Changelog](#changelog) below.

This repository is the home of the Official AlmaLinux Raspberry Pi Image.

Images made possible by the incredible work contributed by the immortal [Pablo Greco](https://github.com/psgreco), [Mark Verlinde](https://github.com/markVnl) and [Fabian Arrotin](https://github.com/arrfab).

## AlmaLinux Raspberry Pi Quick Start
This has been tested on Raspberry Pi 3 and 4.

Please file any bugs on https://bugs.almalinux.org and feel free to discuss on our [Community Chat](https://chat.almalinux.org), the [Forums](https://almalinux.discourse.group/t/about-the-raspberry-pi-category/333) or [Reddit](https://www.reddit.com/r/AlmaLinux/).

**Step 1**: [Grab the image](https://repo.almalinux.org/rpi/images/AlmaLinux-8-RaspberryPi-latest.aarch64.raw.xz), verify the [CHECKSUM](https://repo.almalinux.org/rpi/images/CHECKSUM) and burn it to an SD card using [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter/releases/) , [Balena Etcher](https://www.balena.io/etcher/), RPi Image, dd or whatever tool you choose.

**Step 2**: Insert your SD Card into your Raspberry PI and boot!

**Step 3**: Login. The user is `root` password is `almalinux`.

**Step 4**: Resize your root filesystem by running `rootfs-expand`. (Thanks Fabian!)

## **Bonus Round #1:** Connecting to Wi-Fi.
**WI-FI NOW WORKS OUT OF THE BOX!**

**Step 1**: First, let's make sure wifi is enabled. `nmcli radio wifi` it should respond with `enabled`. Great.

**Step 2**: Check out the list of local Wi-Fi networks next to you `nmcli dev wifi list`. You should see the one you want to connect to here.

**Step 3**: Connect to the Wi-Fi network. We'll use the --ask option so that we can provide the password silently. `nmcli --ask dev wifi connect network-ssid`

**Step 4**: Success! Your wlan0 interface should now pull an IP via DHCP and be active. You can verify this via `nmcli con show` to check physical layer connection and then `ip a` to see if you've gotten an IP.

## **Bonus Round #2**: Getting GNOME working.

[![asciicast](https://asciinema.org/a/423622.svg)](https://asciinema.org/a/423622)

**Step 1**: If you'd like to install just a barebones `GNOME` desktop environment use `dnf groupinstall gnome-desktop` (350MB download, 1.1GB installed). You may have to install additional packages as needed. If you'd like to install a more comprehensive GNOME environment then use `dnf groupinstall "Server with GUI"`. This comes with the GNOME GUI and server utils (890MB download, 2.4GB installed).

**Step 2**: `systemctl set-default graphical`

**Step 3**: `reboot`

**Step 4**: Success!

[![GNOME Desktop on AlmaLinux on Raspberry Pi](https://res.cloudinary.com/marcomontalbano/image/upload/v1625268695/video_to_markdown/images/youtube--HbPRKJrYFbQ-c05b58ac6eb4c4700831b2b3070cd403.jpg)](https://youtu.be/HbPRKJrYFbQ "GNOME Desktop on AlmaLinux on Raspberry Pi")

## After Installation
If you installed a GUI, and your screen has a black border around it, apply this fix:

**Step 1**: Open a terminal

**Step 2**: `sudo nano /boot/config.txt`

**Step 3**: Add the following line: `disable_overscan=1`

**Step 4**: Type Ctrl+x on your keyboard to exit nano, and a little message at the bottom or the terminal will say, “save modified buffer?’. Type y for ‘yes’.

**Step 5**: `reboot`

## Changelog
2021-11-12
- Updated to AlmaLinux 8.5
- Updated Kernel to version 5.10.78

2021-10-05
- Relocated images, added kernels and release packages to RPi-specific repository
- Updated Kernel to version 5.10.60
- Fixed Wi-Fi via an updated `linux-firmware` package to include Matthias Brugger's <mbrugger@suse.com> fix for Raspberry Pi
- Include Fabian Arrotin's <arrfab@centos.org> `rootfs-expand`
- Reduced swap size to 100MB to match Raspberry Pi OS
