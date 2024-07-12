# AlmaLinux Official Raspberry Pi Image

[![asciicast](https://asciinema.org/a/423618.svg)](https://asciinema.org/a/423618)

Last Update 2024-06-27: [Changelog](#changelog) below.

This repository is the home of the Official AlmaLinux Raspberry Pi Image.

Images made possible by the incredible work contributed by the immortal [Pablo Greco](https://github.com/psgreco), [Mark Verlinde](https://github.com/markVnl), [Fabian Arrotin](https://github.com/arrfab) and [Koichiro Iwao](https://github.com/metalefty).

### Tested hardware:
* Raspberry Pi 5 
* Raspberry Pi 4 Model B
* Raspberry Pi 400
* Raspberry Pi 3 Model B+
* Raspberry Pi 3 Model A+

## AlmaLinux Raspberry Pi Quick Start

Please file any bugs on https://bugs.almalinux.org and feel free to discuss on our [Community Chat](https://chat.almalinux.org), the [Forums](https://almalinux.discourse.group/t/about-the-raspberry-pi-category/333) or [Reddit](https://www.reddit.com/r/AlmaLinux/).

**Step 1**: [Grab the image](https://repo.almalinux.org/rpi/images/AlmaLinux-8-RaspberryPi-latest.aarch64.raw.xz), verify the [CHECKSUM](https://repo.almalinux.org/rpi/images/CHECKSUM) and burn it to an SD card using [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter/releases/) , [Balena Etcher](https://www.balena.io/etcher/), [Raspberry Pi Imager](https://www.raspberrypi.com/software/), dd or whatever tool you choose.

**Step 2**: Edit `user-data` file if you want to configure early initialization.

**Step 2**: Insert your SD Card into your Raspberry Pi and boot!

**Step 3**: Login. The default user is `almalinux` and password is `almalinux`.

## AlmaLinux Raspberry Pi Guide
Full guide for AlmaLinux on Raspberry Pi is available here: https://wiki.almalinux.org/documentation/raspberry-pi

## Changelog

### 2024-06-27
- V3D graphic driver is now working on AL8 [#32](https://github.com/AlmaLinux/raspberry-pi/issues/32)

### 2024-06-24
- Enable ondemand CPU frequency scaling [#48](https://github.com/AlmaLinux/raspberry-pi/issues/48)
- V3D graphic driver is now working on AL9 [#32](https://github.com/AlmaLinux/raspberry-pi/issues/32)

### 2024-06-14
- Enable serial console [#47](https://github.com/AlmaLinux/raspberry-pi/pull/47)
- Install utilities for GPIO by default (AL9)

### 2024-06-05
- Update for AlmaLinux 8.10 and 9.4
- Support Raspberry Pi 5

### 2023-06-16
- Update for AlmaLinux 8.8 and 9.2
- Added support for cloud-init
- Added linux-firmware-raspberrypi package to support Raspberry Pi 400 Wi-Fi

### 2021-11-12
- Updated to AlmaLinux 8.5
- Updated Kernel to version 5.10.78

### 2021-10-05
- Relocated images, added kernels and release packages to RPi-specific repository
- Updated Kernel to version 5.10.60
- Fixed Wi-Fi via an updated `linux-firmware` package to include Matthias Brugger's <mbrugger@suse.com> fix for Raspberry Pi
- Include Fabian Arrotin's <arrfab@centos.org> `rootfs-expand`
- Reduced swap size to 100MB to match Raspberry Pi OS
