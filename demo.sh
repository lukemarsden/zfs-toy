#!/bin/bash
docker build -t docker-zfs-demo .
echo "Running docker image, run /setup.sh, "
echo "then use zpool/zfs command in here to play around."
docker run --privileged -v /lib/modules:/lib/modules -v /var/lib/dvol:/var/lib/dvol -ti docker-zfs-demo bash
