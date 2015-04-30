#!/bin/bash

set -e

TARGET_DIR=$1
BUILD_ROOT=$1/../..
echo "$BUILD_ROOT"
echo "Customizing root file system"
CRYPTEDPASS=$(perl -e 'print crypt("doge1234","salt")')
sudo sed -i -e "s#^root:[^:]*:#root:$CRYPTEDPASS:#" ${TARGET_DIR}/etc/shadow
# echo "/dev/mmcblk0p4          /updates         vfat    defaults   0      0" | sudo tee --append ${TARGET_DIR}/etc/fstab

# sed -e "s/auto \(eth.*\)/allow-hotplug \1/g" -i ${TARGET_DIR}/etc/network/interfaces

#echo "allow-hotplug eth1" | sudo tee --append ${TARGET_DIR}/etc/network/interfaces
#echo "iface eth1 inet dhcp" | sudo tee --append ${TARGET_DIR}/etc/network/interfaces
# sudo install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/init.d/S01launch-otto ${TARGET_DIR}/etc/init.d
# sudo install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/init.d/S03loadmodules   ${TARGET_DIR}/etc/init.d
# sudo install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/init.d/*   ${TARGET_DIR}/etc/init.d
sudo install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/udev/rules.d/*   ${TARGET_DIR}/etc/udev/rules.d
sudo install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/avahi/services/*   ${TARGET_DIR}/etc/avahi/services

sudo install -T -m 775 ${BUILD_ROOT}/system/skeleton/etc/fstab ${TARGET_DIR}/etc/fstab
sudo install -d -m 775 ${TARGET_DIR}/var/lib/journal
echo '/dev/mmcblk0p4 /mnt vfat defaults 0 0' | sudo tee --append ${TARGET_DIR}/etc/fstab


stamp=$(date +%s)
D=$(date -d @${stamp} +"%Y-%m-%d %T %s")
echo "**** TIMESTAMP= ${stamp}"
echo "Welcome to stack update ${D}" >${TARGET_DIR}/etc/issue
echo "${stamp}" | sudo tee ${TARGET_DIR}/stak/version
