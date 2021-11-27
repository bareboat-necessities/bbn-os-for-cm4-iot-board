#!/bin/bash -xe

apt-get update
apt-get -y install docker.io wget

cd /root
mkdir project
cd project

git clone https://github.com/bareboat-necessities/bbn-os-for-cm4-iot-board
mv bbn-os-for-cm4-iot-board ci-source
cd ci-source

mv install-scripts-cm4 cross-build-release/
chmod a+x .circleci/*.sh

export DOCKER_IMAGE=arm32v7/debian:buster
export CONTAINER_DISTRO=debian:buster
export PKG_RELEASE=raspbian
export PKG_DISTRO=buster
export PKG_ARCH=armhf
export EMU=on

.circleci/build-ci.sh 2>&1 | tee build.log
