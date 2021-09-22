#!/bin/bash -e

## RaspOS
if [ -f /boot/config.txt ]; then
  sed -i 's#dtparam=audio=on##' /boot/config.txt
	cat $FILE_FOLDER/appendToConfig.txt >> /boot/config.txt
fi

# Cameras
wget https://www.waveshare.com/w/upload/4/41/CM4_dt_blob.7z
7z x CM4_dt_blob.7z -O./CM4_dt_blob
chmod 777 -R CM4_dt_blob
cd CM4_dt_blob/
dtc -I dts -O dtb -o /boot/dt-blob.bin dt-blob-disp0-double_cam.dts
