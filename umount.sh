#!/bin/sh
set -x

mntdir=/tmp/fs
img=alpine.ext4

#sudo mount $img $mntdir
#
#sudo mount -t proc /proc ${mntdir}/proc/
#sudo mount -t sysfs /sys ${mntdir}/sys/
#sudo mount -o bind /dev ${mntdir}/dev/
#
## sudo chroot $mntdir /bin/sh
##
sudo umount ${mntdir}/dev
sudo umount ${mntdir}/proc
sudo umount ${mntdir}/sys

sudo umount $mntdir
