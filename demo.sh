#!/bin/bash
docker build -t docker-zfs-demo .
echo "Running docker image, use 'zfs' command in here to play around."
docker run --privileged -ti -v /dev/zfs:/dev/zfs docker-zfs-demo bash
