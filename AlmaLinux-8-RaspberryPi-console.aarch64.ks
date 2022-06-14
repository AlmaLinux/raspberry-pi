# To build an image run the following as root:
# appliance-creator -c AlmaLinux-8-RaspberryPi-latest.aarch64.ks \
#   -d -v --logfile /var/tmp/AlmaLinux-8-RaspberryPi-latest.aarch64.ks.log \
#   --cache /root/cache --no-compress \
#   -o $(pwd) --format raw --name AlmaLinux-8-RaspberryPi-latest.aarch64 | \
#   tee /var/tmp/AlmaLinux-8-RaspberryPi-latest.aarch64.ks.log.2

# Basic setup information
url --url="https://repo.almalinux.org/almalinux/8/BaseOS/aarch64/os/"
rootpw --plaintext almalinux

# Repositories to use
repo --name="almalinux8-baseos"    --baseurl=https://repo.almalinux.org/almalinux/8/BaseOS/aarch64/os/
repo --name="almalinux8-appstream" --baseurl=https://repo.almalinux.org/almalinux/8/AppStream/aarch64/os/
repo --name="almalinux8-raspberrypi" --baseurl=https://repo.almalinux.org/almalinux/8/raspberrypi/aarch64/os/ --cost=1000 --install

install
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
part swap --asprimary --fstype=swap --size=100 --label=swap
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
cloud-utils-growpart
e2fsprogs
net-tools
raspberrypi2-firmware
raspberrypi2-kernel4
%end

%post
# Mandatory README file
cat >/root/README << EOF
== AlmaLinux 8 ==

If you want to automatically resize your / partition, just type the following (as root user):
rootfs-expand

EOF

cat > /boot/config.txt << EOF
# AlmaLinux doesn't use any default config options to work,
# this file is provided as a placeholder for user options
EOF

# Specific cmdline.txt files needed for raspberrypi2/3
cat > /boot/cmdline.txt << EOF
console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p3 rootfstype=ext4 elevator=deadline rootwait
EOF

# Remove ifcfg-link on pre generated images
rm -f /etc/sysconfig/network-scripts/ifcfg-link

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id
%end

%post --nochroot --erroronfail

/usr/sbin/blkid
LOOPPART=$(cat /proc/self/mounts |/usr/bin/grep '^\/dev\/mapper\/loop[0-9]p[0-9] '"$INSTALL_ROOT " | /usr/bin/sed 's/ .*//g')
echo "Found loop part for PARTUUID $LOOPPART"
BOOTDEV=$(/usr/sbin/blkid $LOOPPART|grep 'PARTUUID="........-03"'|sed 's/.*PARTUUID/PARTUUID/g;s/ .*//g;s/"//g')
echo "no chroot selected bootdev=$BOOTDEV"
if [ -n "$BOOTDEV" ];then
    cat $INSTALL_ROOT/boot/cmdline.txt
    echo sed -i "s|root=/dev/mmcblk0p3|root=${BOOTDEV}|g" $INSTALL_ROOT/boot/cmdline.txt
    sed -i "s|root=/dev/mmcblk0p3|root=${BOOTDEV}|g" $INSTALL_ROOT/boot/cmdline.txt
fi
cat $INSTALL_ROOT/boot/cmdline.txt

# Fix swap partition
UUID_SWAP=$(/bin/grep 'swap'  $INSTALL_ROOT/etc/fstab  | awk '{print $1}' | awk -F '=' '{print $2}')
/usr/sbin/mkswap -L "_swap" -p 4096  -U "${UUID_SWAP}"  /dev/disk/by-uuid/${UUID_SWAP}

%end
