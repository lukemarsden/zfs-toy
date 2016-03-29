#!/bin/bash
modprobe zfs
mknod -m 660 /dev/zfs c $(cat /sys/class/misc/zfs/dev |sed 's/:/ /g')
