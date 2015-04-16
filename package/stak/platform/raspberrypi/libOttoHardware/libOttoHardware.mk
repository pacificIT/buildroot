#############################################################
#
# libOttoHardware
#
#############################################################

LIBOTTOHARDWARE_SITE = git@github.com:NextThingCo/libOttoHardware.git
LIBOTTOHARDWARE_VERSION = 28d840e8db28a571b72e76b6f8d2f911b7f96e36
LIBOTTOHARDWARE_SITE_METHOD = git

LIBOTTOHARDWARE_LICENSE = GPLv2
LIBOTTOHARDWARE_LICENSE_FILES = LICENCE
LIBOTTOHARDWARE_CONF_OPTS = -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard"
LIBOTTOHARDWARE_INSTALL_STAGING = YES
LIBOTTOHARDWARE_INSTALL_TARGET = YES


$(eval $(cmake-package))
