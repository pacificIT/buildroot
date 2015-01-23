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

sudo ${CP} output/build/rpi-firmware-*/boot/bootcode.bin ${BOOT_DIR}/ > /dev/null 2>&1
sudo ${CP} output/build/rpi-firmware-*/boot/start.elf ${BOOT_DIR}/ > /dev/null 2>&1
sudo ${CP} output/build/rpi-firmware-*/boot/start_x.elf ${BOOT_DIR}/ > /dev/null 2>&1
sudo ${CP} output/build/rpi-firmware-*/boot/fixup.dat ${BOOT_DIR}/ > /dev/null 2>&1
#sudo ${CP} output/images/rootfs.cpio.gz ${BOOT_DIR}/ > /dev/null 2>&1
#sudo ${CP} output/images/rpi-firmware/* ${BOOT_DIR}/ > /dev/null 2>&1
sudo ${CP} ${STAK_SUPPORT}/cmdline.txt ${BOOT_DIR}/cmdline.txt > /dev/null 2>&1
sudo ${CP} ${STAK_SUPPORT}/config.txt ${BOOT_DIR}/config.txt > /dev/null 2>&1
sudo ${CP} output/images/zImage ${BOOT_DIR}/kernel.img > /dev/null 2>&1

sudo install -m 775 ${STAK_SUPPORT}/dt-blob.bin				${BOOT_DIR}/
sudo install -m 775 ${STAK_SUPPORT}/root/etc/init.d/S04mountupdate	${ROOT_DIR}/etc/init.d

ROOTSIZE_MB="$(( ( `sudo du -h -s -S --total ${ROOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//'`) + 10))"

BOOTSIZE=`sudo du -h -s -S --total ${BOOT_DIR}/ | tail -1 | cut -f 1 | sed s'/.$//' | awk '{printf("%d\n",$1 + 0.5)}'`
BOOTSIZE_MB="$(( $BOOTSIZE + 4 ))"
TOTAL_SIZE="$(( $ROOTSIZE_MB * 3 + $BOOTSIZE_MB + 2 + 10))"

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
	
	n
	p
	3
	
	+${ROOTSIZE_MB}M
	
	n
	p
	4
	
	+$(( $ROOTSIZE_MB + 10 ))M
	
	t
	1
	e
	t
	4
	e
	a
	1
	w
END
#END

KPARTX_OUTPUT=`sudo ${KPARTX} -al ${IMAGE}`
BOOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==1 {print $1}'`
ROOTLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==2 {print $1}'`
FATLOOP=/dev/mapper/`echo "$KPARTX_OUTPUT" | awk 'NR==4 {print $1}'`
sudo ${KPARTX} -a ${IMAGE}

echo "Bootloop: ${BOOTLOOP}"
echo "Rootloop: ${ROOTLOOP}"
echo "FATloop: ${FATLOOP}"
if [ -d 'sdimage' ]; then
	sudo rm -Rf sdimage
fi
mkdir sdimage
mkdir -p sdimage/root
mkdir -p sdimage/boot
mkdir -p sdimage/updates

sudo ${MKFS_VFAT} -F16 -n BOOT -S 512 ${BOOTLOOP} > /dev/null 2>&1
sudo ${MKFS_EXT4} -T small ${ROOTLOOP} > /dev/null 2>&1
sudo ${MKFS_VFAT} -n UPDATE -S 512 ${FATLOOP} > /dev/null 2>&1

sudo ${MOUNT} -t vfat -w ${BOOTLOOP} sdimage/boot
sudo ${MOUNT} -t ext4 -w ${ROOTLOOP} sdimage/root
sudo ${MOUNT} -t vfat -w ${FATLOOP} sdimage/updates

# modify root file system here
sudo ${CP} -rf ${BOOT_DIR}/* sdimage/boot
sudo ${CP} -rf ${ROOT_DIR}/* sdimage/root
CHECKSUM=`sha256sum output/images/rootfs.ext2 | awk 'NR==1 {print $1}'`
sudo ${CP} output/images/rootfs.ext2 sdimage/updates/
echo "$CHECKSUM *sdimage/updates/rootfs.ext2" | sha256sum -c -


# echo "/dev/mmcblk0p3		/modes	       ext4    defaults	  0	 0" | sudo tee --append sdimage/root/etc/fstab > /dev/null

if [ -f sdimage/root/sbin/init ];
then
	echo "Init exists."
else
	echo "Init does not exist!"
fi

sync && sync > /dev/null 2>&1

df -h
sudo ${UMOUNT} sdimage/updates
sudo ${UMOUNT} sdimage/boot
sudo ${UMOUNT} sdimage/root


sudo ${KPARTX} -d ${IMAGE} > /dev/null 2>&1
sudo rm -Rf sdimage/

sudo rm -rf ${BOOT_DIR}
sudo rm -rf ${ROOT_DIR}
# bzip2 ${IMAGE}

echo "Uploading to S3"

UPLOADNAME=stak-nightly-`date '+%Y-%m-%d-%s'`.img
# s3cmd put --acl-public --no-guess-mime-type --disable-multipart ${IMAGE} s3://stak-images/nightlies/${UPLOADNAME}
echo "Complete!"
