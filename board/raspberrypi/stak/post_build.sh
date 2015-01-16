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

BOOT_DIR=output/sd_card/boot
ROOT_DIR=output/sd_card/root

mkdir -p ${BOOT_DIR}
mkdir -p ${ROOT_DIR}

sudo ${TAR} xvpsf output/images/rootfs.tar -C ${ROOT_DIR} > /dev/null 2>&1

sudo ${CP} output/build/rpi-firmware-*/boot/* ${BOOT_DIR}/ > /dev/null 2>&1
# sudo ${CP} output/build/rpi-firmware-*/boot/start_x.elf ${BOOT_DIR}/start.elf > /dev/null 2>&1
sudo ${CP} output/images/rpi-firmware/* ${BOOT_DIR}/ > /dev/null 2>&1
sudo ${CP} ${STAK_SUPPORT}/cmdline.txt ${BOOT_DIR}/cmdline.txt > /dev/null 2>&1
sudo ${CP} ${STAK_SUPPORT}/config.txt ${BOOT_DIR}/config.txt > /dev/null 2>&1
sudo ${CP} output/images/zImage ${BOOT_DIR}/kernel.img > /dev/null 2>&1

# sudo ${CP} output/images/boot/* sdimage/boot/ > /dev/null 2>&1
sudo install -m 775 ${STAK_SUPPORT}/dt-blob.bin		${BOOT_DIR}/
sudo install -m 775 ${STAK_SUPPORT}/S03loadmodules	${ROOT_DIR}/etc/init.d
sudo install -m 775 ${STAK_SUPPORT}/S06launch-otto	${ROOT_DIR}/etc/init.d
#sudo install -m 775 ${STAK_SUPPORT}/stak/S02setupmdev		${ROOT_DIR}/etc/init.d
#sudo install -m 775 ${STAK_SUPPORT}/stak/S07dhcp			${ROOT_DIR}/etc/init.d
#sudo install -m 775 ${STAK_SUPPORT}/stak/00-vmcs.conf		${ROOT_DIR}/etc/ld.so.conf.d/

ROOTSIZE_MB="$(( ( `sudo du -h -s -S --total ${ROOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//'`) + 10))"

BOOTSIZE=`sudo du -h -s -S --total ${BOOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//' | awk '{printf("%d\n",$1 + 0.5)}'`
BOOTSIZE_MB="$(( $BOOTSIZE + 4 ))"
TOTAL_SIZE="$(( $ROOTSIZE_MB + $BOOTSIZE_MB + 2))"

echo "Boot Size: $BOOTSIZE_MB"
echo "Root Size: $ROOTSIZE_MB"
echo "Total Size: $TOTAL_SIZE"
if [ -d $IMAGE ]; then
	rm ${IMAGE}
fi

if [ -d ${IMAGE}.bz2 ]; then
	rm -f ${IMAGE}.bz2
fi

${DD} if=/dev/zero of=${IMAGE} bs=1MiB count=${TOTAL_SIZE} > /dev/null 2>&1

# partition image
${FDISK} ${IMAGE} > /dev/null 2>&1 <<-END
	o
	n
	p
	1
	
	+${BOOTSIZE_MB}M
	n
	p
	2
	
	+${ROOTSIZE_MB}M
	t
	1
	e
	a
	1
	w
END
#	
#	+64M
#	n
#	p
#	3

KPARTX_OUTPUT=`sudo ${KPARTX} -al ${IMAGE}`
BOOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==1 {print $1}'`
ROOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==2 {print $1}'`
sudo ${KPARTX} -a ${IMAGE}
#		
echo "Bootloop: ${BOOTLOOP}"
echo "Rootloop: ${ROOTLOOP}"
if [ -d 'sdimage' ]; then
	sudo rm -Rf sdimage
fi
mkdir sdimage
mkdir -p sdimage/root
mkdir -p sdimage/boot

sudo ${MKFS_VFAT} -F16 -n BOOT -S 512 ${BOOTLOOP} > /dev/null 2>&1
sudo ${MKFS_EXT4} -T small ${ROOTLOOP} > /dev/null 2>&1

sudo ${MOUNT} -t vfat -w ${BOOTLOOP} sdimage/boot
sudo ${MOUNT} -t ext4 -w ${ROOTLOOP} sdimage/root

# modify root file system here
sudo ${CP} -rf ${BOOT_DIR}/* sdimage/boot
sudo ${CP} -rf ${ROOT_DIR}/* sdimage/root

# echo "/dev/mmcblk0p3		/modes	       ext4    defaults	  0	 0" | sudo tee --append sdimage/root/etc/fstab > /dev/null
CRYPTEDPASS=$(perl -e 'print crypt("doge1234","salt")')
sudo sed -i -e "s#^root:[^:]*:#root:$CRYPTEDPASS:#" sdimage/root/etc/shadow

if [ -f sdimage/root/sbin/init ];
then
	echo "Init exists."
else
	echo "Init does not exist!"
fi

sync && sync > /dev/null 2>&1

df -h
sudo ${UMOUNT} sdimage/boot
sudo ${UMOUNT} sdimage/root

sudo ${KPARTX} -d ${IMAGE} > /dev/null 2>&1
sudo rm -Rf sdimage/
# bzip2 ${IMAGE}

echo "Uploading to S3"

UPLOADNAME=stak-nightly-`date '+%Y-%m-%d-%s'`.img
# s3cmd put --no-guess-mime-type --disable-multipart ${IMAGE} s3://stak-images/nightlies/${UPLOADNAME}
echo "Complete!"