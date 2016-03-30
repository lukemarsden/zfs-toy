#!/bin/bash
set -xe
KERN=$(uname -r)
RELEASE=zfs-${KERN}.tar.gz
curl -f -o ${RELEASE} https://raw.githubusercontent.com/ClusterHQ/zfs-binaries/master/generic/${RELEASE}
# TODO make the binary extract to 'zfs'
if [ -d zfs ]; then
    mv zfs zfs.bak
fi
tar xf ${RELEASE}
sudo depmod -b ~/zfs
sudo modprobe -d ~/zfs zfs
