#!/usr/bin/env bash

sudo su

apt-get -y install docker.io wget

cd /root || exit 1
mkdir project || exit 2
cd project || exit 3

git clone https://github.com/bareboat-necessities/bbn-os-for-cm4-iot-board
mv bbn-os-for-cm4-iot-board ci-source
cd ci-source || exit 4

mv install-scripts-cm4 cross-build-release/
chmod a+x .circleci/*.sh

export DOCKER_IMAGE=arm32v7/debian:buster
export CONTAINER_DISTRO=debian:buster
export PKG_RELEASE=raspbian
export PKG_DISTRO=buster
export PKG_ARCH=armhf
export EMU=on

.circleci/build-ci.sh

