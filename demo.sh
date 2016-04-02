#!/bin/bash
docker build -t docker-zfs-demo .
echo "Running docker image, run /setup.sh, "
echo "then use zpool/zfs command in here to play around."
# TODO only bind-mount /lib/modules if we're on ubuntu 16.04?
# That is: -v /lib/modules:/lib/modules
docker run --privileged -v /var/lib/docker:/var/lib/docker -v /var/lib/dvol:/var/lib/dvol -v /lib:/system-lib -v /bundled-lib -ti docker-zfs-demo bash
