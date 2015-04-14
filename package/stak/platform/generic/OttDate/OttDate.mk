#############################################################
#
# libfoo
#
#############################################################
OTTDATE_VERSION = 1bc48c032e83c8437ac11499144b21fdb949e8f7
OTTDATE_SITE = $(call github,NextThingCo,OttDate,$(OTTDATE_VERSION))
OTTDATE_INSTALL_STAGING = YES
OTTDATE_INSTALL_TARGET = YES
OTTDATE_DEPENDENCIES = host-openssl openssl

$(eval $(cmake-package))