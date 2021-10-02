#!/bin/bash -e

install -m 755 $FILE_FOLDER/canbus-init.sh "/usr/local/sbin/canbus-init"

install -v -m 0644 $FILE_FOLDER/canbus.service "/etc/systemd/system/"

systemctl enable canbus.service
