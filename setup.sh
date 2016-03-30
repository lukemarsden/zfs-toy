#!/bin/bash
set -xe
# inside /var/lib/docker so that we end up on the big partition
# in boot2docker env
DIR=/var/lib/docker/dvol
FILE=${DIR}/dvol_data
POOL=dvol_pool
if [ ! -d $DIR ]; then
    mkdir -p $DIR
fi
if [ ! modinfo zfs >/dev/null 2>&1 ]; then
    modprobe zfs
fi
if [ ! -e /dev/zfs ]; then
    mknod -m 660 /dev/zfs c $(cat /sys/class/misc/zfs/dev |sed 's/:/ /g')
fi
if [ ! -f $FILE ]; then
    truncate -s 100G $FILE
    zpool create $POOL $FILE
elif
    zpool import -d $DIR $POOL
fi
