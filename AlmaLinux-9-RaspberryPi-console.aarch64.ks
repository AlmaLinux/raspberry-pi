# To build an image run the following as root:
# appliance-creator -c AlmaLinux-9-RaspberryPi-latest.aarch64.ks \
#   -d -v --logfile /var/tmp/AlmaLinux-9-RaspberryPi-latest-$(date +%Y%m%d-%s).aarch64.ks.log \
#   --cache /root/cache --no-compress \
#   -o $(pwd) --format raw --name AlmaLinux-9-RaspberryPi-latest-$(date +%Y%m%d-%s).aarch64 | \
#   tee /var/tmp/AlmaLinux-9-RaspberryPi-latest-$(date +%Y%m%d-%s).aarch64.ks.log.2
# Basic setup information
url --url="https://repo.almalinux.org/almalinux/9/BaseOS/aarch64/os/"
rootpw --plaintext almalinux

# Repositories to use
repo --name="baseos"    --baseurl=https://repo.almalinux.org/almalinux/9/BaseOS/aarch64/os/
repo --name="appstream" --baseurl=https://repo.almalinux.org/almalinux/9/AppStream/aarch64/os/
repo --name="raspberrypi" --baseurl=https://repo.almalinux.org/almalinux/9/raspberrypi/aarch64/os/

# install
keyboard us --xlayouts=us --vckeymap=us
timezone --isUtc --nontp UTC
selinux --enforcing
firewall --enabled --port=22:tcp
network --bootproto=dhcp --device=link --activate --onboot=on
services --enabled=sshd,NetworkManager,chronyd
shutdown
bootloader --location=mbr
lang en_US.UTF-8

# Disk setup
clearpart --initlabel --all
part /boot --asprimary --fstype=vfat --size=300 --label=boot
part / --asprimary --fstype=ext4 --size=2400 --label=rootfs

# Package setup
%packages
@core
-caribou*
-gnome-shell-browser-plugin
-java-1.6.0-*
-java-1.7.0-*
-java-11-*
-python*-caribou*
NetworkManager-wifi
almalinux-release-raspberrypi
chrony
cloud-init
cloud-utils-growpart
e2fsprogs
net-tools
linux-firmware-raspberrypi
raspberrypi2-firmware
raspberrypi2-kernel4
nano
%end

%post
# Mandatory README file
cat >/root/README << EOF
== AlmaLinux 9 ==

If you want to automatically resize your / partition, just type the following (as root user):
rootfs-expand

EOF

# Data sources for cloud-init
touch /boot/meta-data /boot/user-data

cat >/boot/user-data << EOF
#cloud-config

hostname: almalinux.local

users:
  - name: almalinux
    groups: [ adm, systemd-journal ]
    sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
    ssh_authorized_keys:
      # Put here your ssh public keys
      #- ssh-ed25519 AAAAC3Nz...
EOF

# root password change motd
cat >/etc/motd << EOF
It's highly recommended to change root password by typing the following:
passwd

To remove this message:
>/etc/motd

EOF

# Allow root SSH login with password
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitrootlogin.conf

cat > /boot/config.txt << EOF
# AlmaLinux doesn't use any default config options to work,
# this file is provided as a placeholder for user options
EOF

# Specific cmdline.txt files needed for raspberrypi2/3
cat > /boot/cmdline.txt << EOF
console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait
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
%end

%post --nochroot --erroronfail

/usr/sbin/blkid
LOOPPART=$(cat /proc/self/mounts |/usr/bin/grep '^\/dev\/mapper\/loop[0-9]p[0-9] '"$INSTALL_ROOT " | /usr/bin/sed 's/ .*//g')
VFATPART=$(cat /proc/self/mounts |/usr/bin/grep '^\/dev\/mapper\/loop[0-9]p[0-9] '"$INSTALL_ROOT"/boot | /usr/bin/sed 's/ .*//g')
echo "Found loop part for PARTUUID $LOOPPART"
BOOTDEV=$(/usr/sbin/blkid $LOOPPART|grep 'PARTUUID="........-02"'|sed 's/.*PARTUUID/PARTUUID/g;s/ .*//g;s/"//g')
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

cat $INSTALL_ROOT/boot/cmdline.txt

%end
