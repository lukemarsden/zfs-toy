FROM ubuntu:16.04
RUN apt-get update && apt-get -y install zfsutils-linux
ADD fetch_zfs_from_clusterhq.sh /
ADD setup.sh /
