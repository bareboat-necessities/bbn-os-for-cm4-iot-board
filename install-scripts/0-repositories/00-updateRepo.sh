#!/bin/bash -e

apt-get update  -y -q
apt-get install -y -q wget gnupg ca-certificates ssl-cert

## Update && Upgrade
apt-get update  -y -q
apt-get upgrade -y -q
