#!/bin/bash -e

apt-get update  -y -q
apt-get install -y -q wget gnupg ca-certificates

## Update && Upgrade
apt-get update  -y -q
apt-get upgrade -y -q
