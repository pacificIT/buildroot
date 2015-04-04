#############################################################
#
# libOttoHardware
#
#############################################################

LIBOTTOHARDWARE_VERSION = 4566362aafd3e4c46891077d6700f7c1f8dd4010
LIBOTTOHARDWARE_SITE = git@github.com:NextThingCo/libOttoHardware.git
LIBOTTOHARDWARE_SITE_METHOD = git
LIBOTTOHARDWARE_LICENSE = GPLv2
LIBOTTOHARDWARE_LICENSE_FILES = LICENCE
LIBOTTOHARDWARE_CFLAGS = $(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard
LIBOTTOHARDWARE_INSTALL_STAGING = YES
LIBOTTOHARDWARE_INSTALL_TARGET = NO


$(eval $(cmake-package))
