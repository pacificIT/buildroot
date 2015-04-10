#!/bin/bash
IMAGE="output/images/rpi-sdimg.img"
STAK_SUPPORT="board/raspberrypi/stak"
FDISK=/sbin/fdisk
KPARTX=/sbin/kpartx
MKFS_EXT4=`which mkfs.ext4`
MKFS_VFAT=`which mkfs.vfat`
TAR=`which tar`
CP=`which cp`
DD=`which dd`
MOUNT=`which mount`
UMOUNT=`which umount`

RECOVERY_BOOT_DIR=output/sd_card/boot-recovery
BOOT_DIR=output/sd_card/boot
ROOT_DIR=output/sd_card/root

#-- mkdir -p ${BOOT_DIR}
#-- mkdir -p ${ROOT_DIR}
#-- #			mkdir -p ${RECOVERY_BOOT_DIR}
#-- #			
#-- #			# get and build otto-recovery-boot-enable binary
#-- #			git clone git@github.com:NextThingCo/otto-recovery-boot-enable.git output/build/otto-recovery-boot-enable > /dev/null 2>&1
#-- #			pushd output/build/otto-recovery-boot-enable/
#-- #			TOOLCHAIN_TRIPLE="arm-none-eabi-" ./build.sh
#-- #			popd
#-- #			
#-- # extract rootfs to ${ROOT_DIR}
#-- sudo ${TAR} xvpsf output/images/rootfs.tar -C ${ROOT_DIR} > /dev/null 2>&1
#-- #			
#-- sudo ${CP} output/build/rpi-firmware-*/boot/bootcode.bin ${BOOT_DIR}/ > /dev/null 2>&1
#-- sudo ${CP} output/build/rpi-firmware-*/boot/start.elf ${BOOT_DIR}/ > /dev/null 2>&1
#-- sudo ${CP} output/build/rpi-firmware-*/boot/start_x.elf ${BOOT_DIR}/ > /dev/null 2>&1
#-- sudo ${CP} output/build/rpi-firmware-*/boot/fixup.dat ${BOOT_DIR}/ > /dev/null 2>&1
#-- #			
#-- sudo ${CP} ${STAK_SUPPORT}/cmdline.txt ${BOOT_DIR}/cmdline.txt > /dev/null 2>&1
#-- sudo ${CP} ${STAK_SUPPORT}/config.txt ${BOOT_DIR}/config.txt > /dev/null 2>&1
#-- sudo install -m 775 ${STAK_SUPPORT}/dt-blob.bin	${BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo install -m 775 output/build/otto-recovery-boot-enable/output/main.bin ${BOOT_DIR}/boot-recovery.img > /dev/null 2>&1
#-- #			
#-- sudo ${CP} output/images/zImage ${BOOT_DIR}/kernel.img > /dev/null 2>&1
#-- #			
#-- #			sudo ${CP} output/build/rpi-firmware-*/boot/bootcode.bin ${RECOVERY_BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo ${CP} output/build/rpi-firmware-*/boot/start.elf ${RECOVERY_BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo ${CP} output/build/rpi-firmware-*/boot/start_x.elf ${RECOVERY_BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo ${CP} output/build/rpi-firmware-*/boot/fixup.dat ${RECOVERY_BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo ${CP} ${STAK_SUPPORT}/boot-recovery/* ${RECOVERY_BOOT_DIR}/ > /dev/null 2>&1
#-- #			sudo install -m 775 ${STAK_SUPPORT}/dt-blob.bin	${RECOVERY_BOOT_DIR}/
#-- #			
#-- #			sudo install -m 775 ${STAK_SUPPORT}/root/etc/init.d/*	${ROOT_DIR}/etc/init.d
#-- #			
#-- ROOTSIZE_MB="256" # "$(( ( `sudo du -h -s -S --total ${ROOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//'`) + 10))"
#-- #			
#-- BOOTSIZE=`sudo du -h -s -S --total ${BOOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//' | awk '{printf("%d\n",$1 + 0.5)}'`
#-- BOOTSIZE_MB="$(( $BOOTSIZE + 4 ))"
#-- #			
#-- RECOVERY_BOOTSIZE="10" #`sudo du -h -s -S --total ${RECOVERY_BOOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//' | awk '{printf("%d\n",$1 + 0.5)}'`
#-- #			
#-- TOTAL_SIZE="$(( $ROOTSIZE_MB + $BOOTSIZE_MB + $RECOVERY_BOOTSIZE + 14))"
#-- 
#-- echo "Boot Size: $BOOTSIZE_MB"
#-- echo "Recovery boot: $RECOVERY_BOOTSIZE"
#-- echo "Root Size: $ROOTSIZE_MB"
#-- echo "Total Size: $TOTAL_SIZE"
#-- if [ -d $IMAGE ]; then
#-- 	rm ${IMAGE}
#-- fi
#-- 
#-- if [ -d ${IMAGE}.bz2 ]; then
#-- 	rm -f ${IMAGE}.bz2
#-- fi
#-- 
#-- ${DD} if=/dev/zero of=${IMAGE} bs=1MiB count=${TOTAL_SIZE} > /dev/null 2>&1
#-- 
#-- # partition image
#-- ${FDISK} ${IMAGE} > /dev/null 2>&1 <<-END
#-- 	o
#-- 	n
#-- 	p
#-- 	1
#-- 	
#-- 	+${BOOTSIZE_MB}M
#-- 	
#-- 	n
#-- 	p
#-- 	2
#-- 	
#-- 	+${RECOVERY_BOOTSIZE}M
#-- 	
#-- 	n
#-- 	p
#-- 	3
#-- 	
#-- 	+$(( $ROOTSIZE_MB + 10 ))M
#-- 	
#-- 	t
#-- 	1
#-- 	e
#-- 	t
#-- 	2
#-- 	e
#-- 	a
#-- 	1
#-- 	w
#-- END
#-- #			#END
#-- #			
#-- KPARTX_OUTPUT=`sudo ${KPARTX} -al ${IMAGE}`
#-- BOOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==1 {print $1}'`
#-- #			RECOVERYLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==2 {print $1}'`
#-- ROOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==3 {print $1}'`
#-- # DATALOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==4 {print $1}'`
#-- #			
#-- sudo ${KPARTX} -a ${IMAGE}
#-- 
#-- echo "Boot loop: ${BOOTLOOP}"
#-- echo "Recovery loop: ${RECOVERYLOOP}"
#-- echo "Root loop: ${ROOTLOOP}"
#-- # echo "Update loop: ${DATALOOP}"
#-- if [ -d 'sdimage' ]; then
#-- 	sudo rm -Rf sdimage
#-- fi
#-- mkdir sdimage
#-- mkdir -p sdimage/root
#-- mkdir -p sdimage/boot
#-- #			mkdir -p sdimage/recovery
#-- mkdir -p sdimage/data
#-- #			
#-- sudo ${MKFS_VFAT} -F16 -n BOOT -S 512 ${BOOTLOOP} > /dev/null 2>&1
#-- #			sudo ${MKFS_VFAT} -F16 -n RECOVERY -S 512 ${RECOVERYLOOP} > /dev/null 2>&1
#-- sudo ${MKFS_EXT4} -T small ${ROOTLOOP} > /dev/null 2>&1
#-- # sudo ${MKFS_VFAT} -n DATA -S 512 ${DATALOOP} > /dev/null 2>&1
#-- 
#-- sudo ${MOUNT} -t vfat -w ${BOOTLOOP} sdimage/boot
#-- #			sudo ${MOUNT} -t vfat -w ${RECOVERYLOOP} sdimage/recovery
#-- sudo ${MOUNT} -t ext4 -w ${ROOTLOOP} sdimage/root
#-- # sudo ${MOUNT} -t vfat -w ${DATALOOP} sdimage/data
#-- #			
#-- sudo ${CP} -rf ${BOOT_DIR}/* sdimage/boot
#-- #			sudo ${CP} -rf ${RECOVERY_BOOT_DIR}/* sdimage/recovery
#-- sudo ${CP} -rf ${ROOT_DIR}/* sdimage/root
#-- #			
#-- #			
#-- CHECKSUM=`sha256sum output/images/rootfs.ext2 | awk 'NR==1 {print $1}'`
#-- # sudo mkdir -p sdimage/data/update/
#-- # sudo ${CP} output/images/rootfs.ext2 sdimage/data/update/
#-- # echo "$CHECKSUM *sdimage/data/update/rootfs.ext2" | sha256sum -c -
#-- #			
#-- #			
#-- #			
#-- if [ -f sdimage/root/sbin/init ];
#-- then
#-- 	echo "Init exists."
#-- else
#-- 	echo "Init does not exist!"
#-- fi
#-- 
#-- sync && sync > /dev/null 2>&1
#-- 
#-- df -h
#-- # sudo ${UMOUNT} sdimage/data
#-- #			sudo ${UMOUNT} sdimage/recovery
#-- sudo ${UMOUNT} sdimage/boot
#-- sudo ${UMOUNT} sdimage/root
#-- #			
#-- #			
#-- sudo ${KPARTX} -d ${IMAGE} > /dev/null 2>&1
#-- sudo rm -Rf sdimage/
#-- 
#-- # sudo rm -rf ${BOOT_DIR}
#-- # sudo rm -rf ${ROOT_DIR}
#-- # bzip2 ${IMAGE}
#-- 


# FWUP Changes

#!/bin/sh

set -e

TARGETDIR=$1
FWUPCONF_NAME=stak-pi-fw.conf

PROJECT_ROOT=$TARGETDIR/../..
FWUP_CONFIG=$PROJECT_ROOT/board/raspberrypi/stak/$FWUPCONF_NAME
FWUP=$PROJECT_ROOT/output/host/usr/bin/fwup

FW_PATH=$PROJECT_ROOT/output/images/raspberrypi.fw
IMG_PATH=$PROJECT_ROOT/${IMAGE}

# Build the firmware image (.fw file)
echo "Creating firmware file..."
PROJECT_ROOT=$PROJECT_ROOT $FWUP -c -f $FWUP_CONFIG -o $FW_PATH

# Build a raw image that can be directly written to
# an SDCard (remove an exiting file so that the file that
# is written is of minimum size. Otherwise, fwup just modifies
# the file. It will work, but may be larger than necessary.)
echo "Creating raw SDCard image file..."
rm -f $IMG_PATH
$FWUP -a -d $IMG_PATH -i $FW_PATH -t complete

echo "Uploading to S3"

BUILDNUMBER=`git rev-list --count --first-parent HEAD`
UPLOADNAME=stak-nightly-`date '+%Y-%m-%d-%s'`-r$BUILDNUMBER.img
echo "$UPLOADNAME" > output/images/latest
#s3cmd put --acl-public --no-guess-mime-type --disable-multipart output/images/latest s3://stak-images/nightlies/latest

# LATEST_IMAGE=`
#s3cmd put --acl-public --no-guess-mime-type --disable-multipart ${IMAGE} s3://stak-images/nightlies/${UPLOADNAME}

UPLOADNAME_FW=stak-fw-nightly-`date '+%Y-%m-%d-%s'`-r$BUILDNUMBER.zip
s3cmd put --acl-public --no-guess-mime-type --disable-multipart ${FW_PATH} s3://stak-images/nightlies/${UPLOADNAME_FW}
# | sed 's/^.\+\(stak\-nightly\-.*\.img\).*$/\1/'`

echo "Uploaded image $UPLOADNAME"
echo "Complete!"

