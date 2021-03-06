#!/bin/bash -xe
{
  source lib.sh

  MY_CPU_ARCH=$1
  LYSMARINE_VER=$2

  thisArch="raspios"
  cpuArch="armhf"
  if [ "arm64" == "$MY_CPU_ARCH" ]; then
    cpuArch="arm64"
  fi

  checkRoot

  # Create caching folder hierarchy to work with this architecture.
  setupWorkSpace $thisArch

  zipName="lysmarine-bbn_2021-11-15-raspios-${cpuArch}.img.xz"
  imageSource="https://github.com/bareboat-necessities/lysmarine_gen/releases/download/v2021-11-15/${zipName}"

# Download the official image
  log "Downloading official image from internet."
  myCache=./cache/$thisArch
  prefix=$myCache/$zipName
{
  echo curl -k -L -o $prefix.part1 $imageSource.part1
  echo curl -k -L -o $prefix.part2 $imageSource.part2
  echo curl -k -L -o $prefix.part3 $imageSource.part3
  echo curl -k -L -o $prefix.part4 $imageSource.part4
  echo curl -k -L -o $prefix.part5 $imageSource.part5
  echo curl -k -L -o $prefix.part6 $imageSource.part6
} | xargs -L 1 -I CMD -P 6 bash -c CMD

  cat $prefix.part? > $myCache/$zipName
  rm $prefix.part?

  7z e -o$myCache/ $myCache/$zipName
  rm $myCache/$zipName

  # Copy image file to work folder add temporary space to it.
  imageName=$(
    cd $myCache
    ls *.img
    cd ../../
  )
  inflateImage $thisArch $myCache/$imageName

  # copy ready image from cache to the work dir
  cp -fv $myCache/$imageName-inflated ./work/$thisArch/$imageName

  # Mount the image and make the binds required to chroot.
  mountImageFile $thisArch ./work/$thisArch/$imageName

  # Copy the lysmarine and origine OS config files in the mounted rootfs
  addLysmarineScripts $thisArch

  mkRoot=work/${thisArch}/rootfs
  ls -l $mkRoot

  mkdir -p ./cache/${thisArch}/stageCache
  mkdir -p $mkRoot/install-scripts-cm4/stageCache
  mkdir -p /run/shm
  mkdir -p $mkRoot/run/shm
  mount -o bind /etc/resolv.conf $mkRoot/etc/resolv.conf
  mount -o bind /dev $mkRoot/dev
  mount -o bind /sys $mkRoot/sys
  mount -o bind /proc $mkRoot/proc
  mount -o bind /tmp $mkRoot/tmp
  mount --rbind $myCache/stageCache $mkRoot/install-scripts-cm4/stageCache
  mount --rbind /run/shm $mkRoot/run/shm
  chroot $mkRoot /bin/bash -xe <<EOF
    set -x; set -e; cd /install-scripts-cm4; export LMBUILD="raspios"; ls; chmod +x *.sh; ./install.sh 0 2 a; exit
EOF

  # Unmount
  umountImageFile $thisArch ./work/$thisArch/$imageName

  ls -l ./work/$thisArch/$imageName
  wget "https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh" -P $myCache/
  chmod +x "$myCache"/pishrink.sh
  "$myCache"/pishrink.sh -s ./work/$thisArch/$imageName || if [ $? == 11 ]; then
    log "Image already shrunk to smallest size"
  fi
  ls -l ./work/$thisArch/$imageName

  # Renaming the OS and moving it to the release folder.
  cp -v ./work/$thisArch/$imageName ./release/$thisArch/bbn-marine-os-cm4-iot_${LYSMARINE_VER}-${thisArch}-${cpuArch}.img

  exit 0
}
