#!/bin/bash -e

/usr/sbin/ip link set can0 up type can bitrate 1000000
/usr/sbin/ifconfig can0 txqueuelen 65536
