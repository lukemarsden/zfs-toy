#!/bin/bash
set -xe

function fetch_zfs_from_clusterhq {
    KERN=$(uname -r)
    RELEASE=zfs-${KERN}.tar.gz
    cd /bundled-lib
    if [ -d /bundled-lib/modules ]; then
        # Try loading a cached module (which we cached in a docker
        # volume)
        depmod -b /bundled-lib || true
        if modprobe -d /bundled-lib zfs; then
            echo "Successfully loaded cached ClusterHQ-provided ZFS for $KERN :)"
            return
        else
            echo "Unable to load cached module, trying to fetch one (maybe you upgraded your kernel)..."
        fi
    fi
    if ! curl -f -o ${RELEASE} https://raw.githubusercontent.com/ClusterHQ/zfs-binaries/master/generic/${RELEASE}; then
        echo "ZFS is not installed on your docker host, and unable to find a ClusterHQ-provided kernel module for your kernel: $KERN"
        echo "Please create a new GitHub issue, pasting this error message, and tell us which Linux distribution you are using, at:"
        echo
        echo "    https://github.com/clusterhq/dvol/issues"
        echo
        echo "Meanwhile, you should still be able to use dvol if you install ZFS manually on your host system by following the instructions at http://zfsonlinux.org/ and then re-run the dvol install script."
        echo
        echo "Alternatively, ClusterHQ provide kernel modules for boot2docker, so if you use docker-machine to create a local docker VM in VirtualBox, dvol should work for you."
        exit 1
    fi
    tar xf ${RELEASE}
    depmod -b /bundled-lib || true
    modprobe -d /bundled-lib zfs
    echo "Successfully loaded downloaded ClusterHQ-provided ZFS for $KERN :)"
}

# Put the data file inside /var/lib/docker so that we end up on the big
# partition in boot2docker env
DIR=/var/lib/docker/dvol
FILE=${DIR}/dvol_data
POOL=dvol_pool

# Docker volume where we can cache downloaded, clusterhq provided,
# "bundled" zfs
BUNDLED_LIB=/bundled-lib
# Bind-mounted system library where we can attempt to modprobe any
# system-provided zfs modules (e.g. Ubuntu 16.04) or manually installed
# by user
SYSTEM_LIB=/system-lib

if [ ! -d $DIR ]; then
    mkdir -p $DIR
fi
if ! modinfo zfs >/dev/null 2>&1; then
    depmod -b /system-lib || true
    if ! modprobe -d /system-lib zfs; then
        fetch_zfs_from_clusterhq
    else
        echo "Successfully loaded system ZFS :)"
    fi
else
    echo "ZFS already loaded :)"
fi
if [ ! -e /dev/zfs ]; then
    mknod -m 660 /dev/zfs c $(cat /sys/class/misc/zfs/dev |sed 's/:/ /g')
fi
if [ ! -f $FILE ]; then
    truncate -s 10240G $FILE
    zpool create $POOL $FILE
elif ! zpool status $POOL; then
    zpool import -d $DIR $POOL
fi

exec "@$"
