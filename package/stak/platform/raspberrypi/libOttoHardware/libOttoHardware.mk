#############################################################
#
# libOttoHardware
#
#############################################################

LIBOTTOHARDWARE_SITE = /home/ubuntu/libOttoHardware
LIBOTTOHARDWARE_SITE_METHOD = local

# LIBOTTOHARDWARE_SITE = git@github.com:NextThingCo/libOttoHardware.git
# LIBOTTOHARDWARE_BRANCH = HEAD
# LIBOTTOHARDWARE_VERSION = 4566362aafd3e4c46891077d6700f7c1f8dd4010
# `eval git ls-remote $(LIBOTTOHARDWARE_SITE) | grep $(LIBOTTOHARDWARE_BRANCH) | awk '{ print $1 }'`
# LIBOTTOHARDWARE_SITE_METHOD = git

LIBOTTOHARDWARE_LICENSE = GPLv2
LIBOTTOHARDWARE_LICENSE_FILES = LICENCE
LIBOTTOHARDWARE_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard"
LIBOTTOHARDWARE_INSTALL_STAGING = YES
LIBOTTOHARDWARE_INSTALL_TARGET = YES


$(eval $(cmake-package))
