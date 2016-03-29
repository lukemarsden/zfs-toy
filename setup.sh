#!/bin/bash
echo mknod -m 660 /dev/zfs c $(cat /sys/class/misc/zfs/dev |sed 's/:/ /g')
