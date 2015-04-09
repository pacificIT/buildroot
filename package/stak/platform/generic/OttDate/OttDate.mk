#############################################################
#
# libfoo
#
#############################################################
OTTDATE_VERSION = v0.0.3
OTTDATE_SITE = $(call github,NextThingCo,OttDate,$(OTTDATE_VERSION))
OTTDATE_INSTALL_STAGING = YES
OTTDATE_INSTALL_TARGET = YES
#OTTDATE_DEPENDENCIES = host-libaaa libbbb

$(eval $(cmake-package))
