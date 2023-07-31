# Firecracker test

More details: https://blg.tch.re/firecracker-getting-started.html

## References

* https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md
* https://github.com/firecracker-microvm/firecracker/blob/main/docs/rootfs-and-kernel-setup.md
* https://github.com/anyfiddle/firecracker-rootfs-builder/blob/main/create-rootfs.sh
* https://github.com/firecracker-microvm/firecracker-demo/
* https://github.com/firecracker-microvm/firectl/

## create a kernel image

https://github.com/firecracker-microvm/firecracker/blob/fea3897ccfab0387ce5cd4fa2dd49d869729d612/docs/rootfs-and-kernel-setup.md

## Create an image from a docker container

⚠ I had issues mounting devfs.

```
$ ./rootfs_docker.sh alpine:3.14 alpine3.14
```

## Create an image from alpine

```
$ ./rootfs_alpine.sh
```
