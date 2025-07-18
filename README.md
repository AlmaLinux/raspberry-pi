# AlmaLinux Official Raspberry Pi Image

[![asciicast](https://asciinema.org/a/423618.svg)](https://asciinema.org/a/423618)

See below for [Changelog](#changelog).

This repository is the home of the Official AlmaLinux Raspberry Pi Image.

Images made possible by the incredible work contributed by the immortal [Pablo Greco](https://github.com/psgreco), [Mark Verlinde](https://github.com/markVnl), [Fabian Arrotin](https://github.com/arrfab) and [Koichiro Iwao](https://github.com/metalefty).

### Tested hardware

|Model |8|9|Kitten 10|10|
|-|-|-|-|-|
|Pi 5|✓|✓|✓|✓|
|Pi 500|?|?|?|?|
|Pi 4 Model B|✓|✓|✓|✓|
|Pi 400|✓|✓|✓|✓|
|Pi 3 Model B+|✓|✓|⛔|⛔|
|Pi 3 Model A+|✓|✓|⛔|⛔|
|Pi 3 Model B|✓|✓|⛔|⛔|

- ✓: Tested
- ?: Not Tested
- ⛔: No Longer Supported

### Available Parition Types

|Version|MBR|GPT|
|-|-|-|
|8|✓||
|9|✓|✓|
|Kitten 10||✓|
|10||✓|

## AlmaLinux Raspberry Pi Quick Start

Please file any bugs on https://bugs.almalinux.org and feel free to discuss on our [Community Chat](https://chat.almalinux.org), the [Forums](https://forums.almalinux.org/t/about-the-raspberry-pi-category/333) or [Reddit](https://www.reddit.com/r/AlmaLinux/).

**Step 1**: [Grab the image](https://repo.almalinux.org/rpi/images/AlmaLinux-8-RaspberryPi-latest.aarch64.raw.xz), verify the [CHECKSUM](https://repo.almalinux.org/rpi/images/CHECKSUM) and burn it to an SD card using [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter/releases/) , [Balena Etcher](https://www.balena.io/etcher/), [Raspberry Pi Imager](https://www.raspberrypi.com/software/), dd or whatever tool you choose.

**Step 2**: Edit `user-data` file if you want to configure early initialization.

**Step 2**: Insert your SD Card into your Raspberry Pi and boot!

**Step 3**: Login. The default user is `almalinux` and password is `almalinux`.

## AlmaLinux Raspberry Pi Guide
Full guide for AlmaLinux on Raspberry Pi is available here: https://wiki.almalinux.org/documentation/raspberry-pi

## Changelog

### 2025-07-17
- Support for Raspberry Pi 3B has been enhanced due to @FingerlessGlov3s 's substantial contributions

### 2025-06-24
- Use auto_initramfs for XFS / LUKS

### 2025-05-30
- Fix Bluetooth was not working on AlmaLinux 9, 10, Kitten 10 GPT images

### 2025-05-28
- Add AlmaLinux 10

### 2025-02-25
- Run SELinux auto-relabel at first boot

### 2025-02-14
- Add AlmaLinux Kitten 10

### 2024-11-21
- Add new images with GUID partition table for AL9
- Update Github workflow to enable building both GPT and MBR images 
- Merge build script into one

### 2024-07-24
- Adjust udev rules to enable serial console and bluetooth concurrently on Pi 5

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
