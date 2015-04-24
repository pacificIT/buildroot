#############################################################
#
# nanovsg
#
#############################################################

NANOSVG_VERSION = master
NANOSVG_SITE = git@github.com:memononen/nanosvg.git
NANOSVG_SITE_METHOD = git
NANOSVG_LICENSE = GPLv2
NANOSVG_LICENSE_FILES = LICENCE
NANOSVG_INSTALL_STAGING = YES
NANOSVG_INSTALL_TARGET = NO


define NANOSVG_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/nanosvg.h $(STAGING_DIR)/usr/include/nanosvg.h
endef

$(eval $(generic-package))