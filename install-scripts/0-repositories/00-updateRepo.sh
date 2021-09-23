#!/bin/bash -e

apt-get update  -y -q || if [ $? == 100 ]; then true; fi
apt-get install -y -q wget gnupg ca-certificates ssl-cert || if [ $? == 100 ]; then true; fi

## Update && Upgrade
apt-get update  -y -q || if [ $? == 100 ]; then true; fi
apt-get upgrade -y -q || if [ $? == 100 ]; then true; fi
