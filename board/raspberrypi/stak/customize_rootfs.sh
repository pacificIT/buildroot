#!/bin/bash

CRYPTEDPASS=$(perl -e 'print crypt("doge1234","salt")')
sudo sed -i -e "s#^root:[^:]*:#root:$CRYPTEDPASS:#" ${TARGET_DIR}/etc/shadow
echo "/dev/mmcblk0p4          /updates         vfat    defaults   0      0" | sudo tee --append ${TARGET_DIR}/etc/fstab
