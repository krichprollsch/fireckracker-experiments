##!/bin/sh

cat << 'EOF' > /etc/hosts
127.0.0.1   localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

cat << 'EOF' > /etc/resolv.conf
nameserver 8.8.8.8
EOF

apk add --update --no-cache --initdb alpine-baselayout apk-tools busybox \
    ca-certificates util-linux dhcpcd \
    openssh \
    openrc
rm -rf /var/cache/apk/*

# Setting up the agetty service
# see https://github.com/OpenRC/openrc/blob/master/agetty-guide.md
ln -s agetty /etc/init.d/agetty.ttyS0
echo ttyS0 > /etc/securetty
rc-update add agetty.ttyS0

rc-update add devfs
rc-update add procfs
rc-update add sysfs
rc-update add local
rc-update add sshd

echo "root:root" | chpasswd

sed -i 's/root:!/root:*/' /etc/shadow

ssh-keygen -A

# copy here you own ssh public key
KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbfoivY5b9fuV6fvOHJrlaagSXEKuk7agIqCaqucq2esJm86vMu8ToXN2yDZxIGwEWFF11O7EGKiwa6CLF1bIhu3SmSpSPBFTzOV5+GJHUXYUhaaWoyKn/I4qOxNqokyze08P68KTKNYlybq4IL5Sp/SBrsjF+Weg2Pvm1s8o0F1hDeTsgN8WhWH6vUScvNceGkNwuXrytc6zp49NplisyozKuTUKTuuPlrK5TIhdKdOE5Q4w1Xj80PeyRufN5m32wYjb1js/mlqPC2OIhqUJ/ChQ+uC2isxECGJn0EWZUSuKopdGGmfmhYI9VqSbT3IlV95Z3zQUNGMGSaxo0RmMt'

mkdir -p /root/.ssh
chmod 0700 /root/.ssh
echo $KEY > /root/.ssh/authorized_keys
