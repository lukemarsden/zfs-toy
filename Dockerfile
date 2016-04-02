FROM ubuntu:16.04
RUN apt-get update && apt-get -y install zfsutils-linux curl
ADD setup.sh /
