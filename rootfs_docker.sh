#!/usr/bin/env sh
set -e -x

# Create a rootfs file from docker container
# See https://github.com/anyfiddle/firecracker-rootfs-builder/blob/main/create-rootfs.sh
# usage: ./rootfs_docker.sh <docker image> <output name>

docker_image=$1
output_name=${2:-image.ext4}
mntdir=/tmp/rootfs

# create and export docker container
container_export=/tmp/rootfs.tar

echo "create and export docker container from ${docker_image} into ${container_export}"

rm -fr $container_export
containerId=$(docker container create $docker_image)
docker export $containerId > $container_export
docker container rm $containerId

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

# export docker container into a mounted ext4 file
echo "extract the docker container into ${output}"

sudo tar -C $mntdir -xf $container_export
# delete the docker export
rm -fr $container_export

# # prepare the rootfs
init=init.sh
sudo mount -t proc /proc ${mntdir}/proc/
sudo mount -t sysfs /sys ${mntdir}/sys/
sudo mount -o bind /dev ${mntdir}/dev/

sudo cp $init $mntdir
sudo chroot $mntdir /bin/sh $init
sudo rm ${mntdir}/${init}

sudo umount ${mntdir}/dev
sudo umount ${mntdir}/proc
sudo umount ${mntdir}/sys

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
