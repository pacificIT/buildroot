#!/bin/bash

set -e

TARGET_DIR=$1
BUILD_ROOT=$1/../..
echo "$BUILD_ROOT"
echo "Customizing root file system"
CRYPTEDPASS=$(perl -e 'print crypt("doge1234","salt")')
sed -i -e "s#^root:[^:]*:#root:$CRYPTEDPASS:#" ${TARGET_DIR}/etc/shadow

if ! [ -f ${TARGET_DIR}/etc/ssh/ssh_host_key ]; then
	ssh-keygen -t rsa1 -f ${TARGET_DIR}/etc/ssh/ssh_host_key -C '' -N ''
fi
if ! [ -f ${TARGET_DIR}/etc/ssh/ssh_host_rsa_key ]; then
	ssh-keygen -t rsa -f ${TARGET_DIR}/etc/ssh/ssh_host_rsa_key -C '' -N ''
fi
if ! [ -f ${TARGET_DIR}/etc/ssh/ssh_host_dsa_key ]; then
	ssh-keygen -t dsa -f ${TARGET_DIR}/etc/ssh/ssh_host_dsa_key -C '' -N ''
fi
if ! [ -f ${TARGET_DIR}/etc/ssh/ssh_host_ecdsa_key ]; then
	ssh-keygen -t ecdsa -f ${TARGET_DIR}/etc/ssh/ssh_host_ecdsa_key -C '' -N ''
fi
if ! [ -f ${TARGET_DIR}/etc/ssh/ssh_host_ed25519_key ]; then
	ssh-keygen -t ed25519 -f ${TARGET_DIR}/etc/ssh/ssh_host_ed25519_key -C '' -N ''
fi

install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/udev/rules.d/*   ${TARGET_DIR}/etc/udev/rules.d
install -m 775 ${BUILD_ROOT}/board/raspberrypi/stak/root/etc/avahi/services/*   ${TARGET_DIR}/etc/avahi/services

install -T -m 775 ${BUILD_ROOT}/system/skeleton/etc/fstab ${TARGET_DIR}/etc/fstab
install -d -m 775 ${TARGET_DIR}/var/lib/journal
echo '/dev/mmcblk0p4 /mnt vfat defaults 0 0' | tee --append ${TARGET_DIR}/etc/fstab

# chown root:root ${TARGET_DIR}/etc/ssh/ssh_host_*
# chown root:root ${TARGET_DIR}/etc/udev/rules.d/*
# chown root:root ${TARGET_DIR}/etc/avahi/services/*


stamp=$(date +%s)
D=$(date -d @${stamp} +"%Y-%m-%d %T %s")
echo "**** TIMESTAMP= ${stamp}"
echo "Welcome to stack update ${D}" >${TARGET_DIR}/etc/issue
echo "${stamp}" | tee ${TARGET_DIR}/stak/version
echo "PermitRootLogin yes" >> ${TARGET_DIR}/etc/ssh/sshd_config
if [[ -f "${PROJECT_ROOT}/.stak-config" ]]; then
	source <(grep = ${PROJECT_ROOT}/.stak-config | sed 's/ *= */=/g' | sed 's/\./_/g')
	if [ $build_type == "release" ]; then
		if [ -f ${TARGET_DIR}/stak/updateurl ]; then
			rm ${TARGET_DIR}/stak/updateurl
		fi
	#else
	#	echo "http://update.s-t-a-k.com/unstable" > ${TARGET_DIR}/stak/updateurl
	fi
fi
