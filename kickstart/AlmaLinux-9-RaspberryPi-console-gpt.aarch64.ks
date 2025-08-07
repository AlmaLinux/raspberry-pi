# Basic setup information
url --mirrorlist="https://mirrors.almalinux.org/mirrorlist/9/baseos"
# root password is locked but can be reset by cloud-init later
rootpw --plaintext --lock almalinux

# Repositories to use
repo --name="baseos"      --mirrorlist="https://mirrors.almalinux.org/mirrorlist/9/baseos"
repo --name="appstream"   --mirrorlist="https://mirrors.almalinux.org/mirrorlist/9/appstream"
repo --name="raspberrypi" --mirrorlist="https://mirrors.almalinux.org/mirrorlist/9/raspberrypi"

# install
keyboard us --xlayouts=us --vckeymap=us
timezone --utc UTC
selinux --enforcing
firewall --enabled --port=22:tcp
network --bootproto=dhcp --device=link --activate --onboot=on
services --enabled=sshd,NetworkManager,chronyd,bluetooth,cpupower
shutdown
bootloader --location=none
lang en_US.UTF-8

# Disk setup
clearpart --initlabel --all --disklabel=gpt
part /boot --fstype=vfat --size=500 --label=cidata --ondisk=sda
part / --fstype=ext4 --size=2400 --label=rootfs --ondisk=sda

# Package setup
%packages
@core
-gnome-shell-browser-plugin
-java-1.8.0-*
-java-11-*
-java-17-*
-java-21-*
-kernel-tools
NetworkManager-wifi
almalinux-release-raspberrypi
bluez
chrony
cloud-init
cloud-utils-growpart
e2fsprogs
net-tools
linux-firmware-raspberrypi
linux-firmware-raspberrypi-rpi3
raspberrypi-sys-mods
raspberrypi-userland
raspberrypi2-firmware
raspberrypi2-kernel4
raspberrypi2-kernel4-tools
nano
libgpiod-utils
%end

%post
# Mandatory README file
cat >/boot/README.txt << EOF
== AlmaLinux 9 ==

To login to Raspberry Pi via SSH, you need to register SSH public key *before*
inserting SD card to Raspberry Pi. Edit user-data file and put SSH public key
in the place.

Default SSH username is almalinux.

EOF

# Data sources for cloud-init
touch /boot/meta-data /boot/user-data

cat >/boot/user-data << "EOF"
#cloud-config
#
# This is default cloud-init config file for AlmaLinux Raspberry Pi image.
#
# If you want additional customization, refer to cloud-init documentation and
# examples. Please note configurations written in this file will be usually
# applied only once at very first boot.
#
# https://cloudinit.readthedocs.io/en/latest/reference/examples.html

hostname: almalinux.local
ssh_pwauth: false

users:
  - name: almalinux
    groups: [ adm, systemd-journal ]
    sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
    lock_passwd: false
    passwd: $6$EJCqLU5JAiiP5iSS$wRmPHYdotZEXa8OjfcSsJ/f1pAYTk0/OFHV1CGvcszwmk6YwwlZ/Lwg8nqjRT0SSKJIMh/3VuW5ZBz2DqYZ4c1
    # Uncomment below to add your SSH public keys as YAML array
    #ssh_authorized_keys:
      #- ssh-ed25519 AAAAC3Nz...

EOF

cat > /boot/config.txt << EOF
# This file is provided as a placeholder for user options
# AlmaLinux - few default config options
[all]
auto_initramfs=1

[pi4]
arm_boost=1

[all]
# enable serial console
enable_uart=1
EOF

# Kernel command line string
cat > /boot/cmdline.txt << EOF
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait
EOF

# Create and initialize swapfile
(umask 077; dd if=/dev/zero of=/swapfile bs=1M count=100)
/usr/sbin/mkswap -p 4096 -L "_swap" /swapfile
cat >> /etc/fstab << EOF
/swapfile	none	swap	defaults	0	0
EOF

# Remove ifcfg-link on pre generated images
rm -f /etc/sysconfig/network-scripts/ifcfg-link

# rebuild dnf cache
dnf clean all
/bin/date +%Y%m%d_%H%M > /etc/BUILDTIME
echo '%_install_langs C.utf8' > /etc/rpm/macros.image-language-conf
echo 'LANG="C.utf8"' >  /etc/locale.conf
rpm --rebuilddb

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id

#auto relabel SELinux
touch /.autorelabel

%end

%post --nochroot --erroronfail

LOOPPART=$(cat /proc/self/mounts |/usr/bin/grep '^\/dev\/mapper\/loop[0-9]p[0-9] '"$INSTALL_ROOT " | /usr/bin/sed 's/ .*//g')
VFATPART=$(cat /proc/self/mounts |/usr/bin/grep '^\/dev\/mapper\/loop[0-9]p[0-9] '"$INSTALL_ROOT"/boot | /usr/bin/sed 's/ .*//g')
echo "Found loop part for PARTUUID $LOOPPART"
BOOTDEV=$(/usr/sbin/blkid $LOOPPART | egrep 'PARTUUID="([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{12})"' | sed 's/.*PARTUUID/PARTUUID/g;s/ .*//g;s/"//g')
echo "no chroot selected bootdev=$BOOTDEV"
if [ -n "$BOOTDEV" ];then
    cat $INSTALL_ROOT/boot/cmdline.txt
    echo sed -i "s|root=/dev/mmcblk0p2|root=${BOOTDEV}|g" $INSTALL_ROOT/boot/cmdline.txt
    sed -i "s|root=/dev/mmcblk0p2|root=${BOOTDEV}|g" $INSTALL_ROOT/boot/cmdline.txt
fi

# cloud-init: NoCloud data source must have volume label "CIDATA"
#
# This didn't work for some reasons so using fatlabel instead.
#    part /boot --asprimary --fstype=vfat --mkfsoptions="-n CIDATA"
/usr/sbin/fatlabel $VFATPART "CIDATA"
# Kickstart sets the type of a VFAT partition with mountpoint /boot to EF00
# if a GUID partition table is used, so reset the partition type to 0700.
VFATPARTNUM=$(echo ${VFATPART} | sed -n 's/.*p\([0-9]\+\)$/\1/p')
VFATPARTDEV=$(echo ${VFATPART//\/mapper/} | sed 's/p[0-9]*$//')
if [ -b "${VFATPARTDEV}p${VFATPARTNUM}" -o -b "${VFATPARTDEV}${VFATPARTNUM}" ]; then
echo /usr/sbin/sgdisk --typecode="${VFATPARTNUM}:0700" ${VFATPARTDEV}
/usr/sbin/sgdisk --typecode="${VFATPARTNUM}:0700" ${VFATPARTDEV}
fi

/usr/sbin/sgdisk -p ${VFATPARTDEV}

cat $INSTALL_ROOT/boot/cmdline.txt

%end
