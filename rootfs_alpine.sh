#!/usr/bin/env sh
set -e -x

# Create a rootfs file by using alpine-make-rootfs
# See https://github.com/alpinelinux/alpine-make-rootfs

alpine_release='v3.18'
output_name=alpine.${alpine_release}.ext4
mntdir=/tmp/rootfs

# create a mounted ext4 file

output_dir=/tmp/rootfs_output
output=${output_dir}/${output_name}

echo "create a mounted ext4 file ${output}"

# prepare output
mkdir -p $output_dir

# create empty image
rm -f ${output}
truncate -s 100M ${output}
/usr/sbin/mkfs.ext4 ${output}

# mount the image
rm -rf $mntdir
mkdir -p $mntdir
sudo mount -o loop $output $mntdir

echo "run alpine-make-rootfs"

sudo ./alpine-make-rootfs \
    --branch ${alpine_release} \
    --script-chroot \
    --packages='ca-certificates util-linux openssh dhcpcd openrc udev-init-scripts-openrc rng-tools' \
    ${mntdir} - <<'SHELL'
ssh-keygen -A

# Setting up the agetty service
# see https://github.com/OpenRC/openrc/blob/master/agetty-guide.md
ln -s agetty /etc/init.d/agetty.ttyS0
echo ttyS0 > /etc/securetty
rc-update add agetty.ttyS0

rc-update add devfs sysinit
rc-update add procfs sysinit
rc-update add sysfs sysinit
rc-update add local
rc-update add sshd

echo "root:root" | chpasswd

KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbfoivY5b9fuV6fvOHJrlaagSXEKuk7agIqCaqucq2esJm86vMu8ToXN2yDZxIGwEWFF11O7EGKiwa6CLF1bIhu3SmSpSPBFTzOV5+GJHUXYUhaaWoyKn/I4qOxNqokyze08P68KTKNYlybq4IL5Sp/SBrsjF+Weg2Pvm1s8o0F1hDeTsgN8WhWH6vUScvNceGkNwuXrytc6zp49NplisyozKuTUKTuuPlrK5TIhdKdOE5Q4w1Xj80PeyRufN5m32wYjb1js/mlqPC2OIhqUJ/ChQ+uC2isxECGJn0EWZUSuKopdGGmfmhYI9VqSbT3IlV95Z3zQUNGMGSaxo0RmMt'

mkdir -p /root/.ssh
chmod 0700 /root/.ssh
echo $KEY > /root/.ssh/authorized_keys

# no modules
rm -f /etc/init.d/modules
SHELL

# unmount the image
sudo umount $mntdir
rm -fr $mntdir

# check image fs
/usr/sbin/e2fsck -y -f $output

# resize image
/usr/sbin/resize2fs -M $output

# check image fs
/usr/sbin/e2fsck -y -f $output

echo "rootfs ready: ${output}"
