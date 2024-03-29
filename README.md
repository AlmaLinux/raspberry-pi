# AlmaLinux Official Raspberry Pi Image

[![asciicast](https://asciinema.org/a/423618.svg)](https://asciinema.org/a/423618)

Last Update 2023-06-16: [Changelog](#changelog) below.

This repository is the home of the Official AlmaLinux Raspberry Pi Image.

Images made possible by the incredible work contributed by the immortal [Pablo Greco](https://github.com/psgreco), [Mark Verlinde](https://github.com/markVnl), [Fabian Arrotin](https://github.com/arrfab) and [Koichiro Iwao](https://github.com/metalefty)

## AlmaLinux Raspberry Pi Quick Start
This has been tested on Raspberry Pi 3 and 4.

Please file any bugs on https://bugs.almalinux.org and feel free to discuss on our [Community Chat](https://chat.almalinux.org), the [Forums](https://almalinux.discourse.group/t/about-the-raspberry-pi-category/333) or [Reddit](https://www.reddit.com/r/AlmaLinux/).

**Step 1**: [Grab the image](https://repo.almalinux.org/rpi/images/AlmaLinux-8-RaspberryPi-latest.aarch64.raw.xz), verify the [CHECKSUM](https://repo.almalinux.org/rpi/images/CHECKSUM) and burn it to an SD card using [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter/releases/) , [Balena Etcher](https://www.balena.io/etcher/), RPi Image, dd or whatever tool you choose.

**Step 2**: Insert your SD Card into your Raspberry PI and boot!

**Step 3**: Login. The user is `almalinux` password is `almalinux`.

**Step 4**: Resize your root filesystem by running `sudo rootfs-expand`. (Thanks Fabian!)

## AlmaLinux Raspberry Pi Guide
Full guide for AlmaLinux on Raspberry Pi is available here: https://wiki.almalinux.org/documentation/raspberry-pi

## Changelog
2023-06-16
- Update for AlmaLinux 8.8 and 9.2
- Added support for cloud-init
- Added linux-firmware-raspberrypi package to support Raspberry Pi 400 Wi-Fi

2021-11-12
- Updated to AlmaLinux 8.5
- Updated Kernel to version 5.10.78

2021-10-05
- Relocated images, added kernels and release packages to RPi-specific repository
- Updated Kernel to version 5.10.60
- Fixed Wi-Fi via an updated `linux-firmware` package to include Matthias Brugger's <mbrugger@suse.com> fix for Raspberry Pi
- Include Fabian Arrotin's <arrfab@centos.org> `rootfs-expand`
- Reduced swap size to 100MB to match Raspberry Pi OS
