#############################################################
#
# otto-update
#
#############################################################

OTTOUPDATE_VERSION = test2
OTTOUPDATE_SITE = file://$(TOPDIR)/package/stak/platform/raspberrypi/ottoupdate
OTTOUPDATE_SOURCE = otto-update-$(OTTOUPDATE_VERSION).tar.gz
OTTOUPDATE_LICENSE = GPLv2
OTTOUPDATE_LICENSE_FILES = LICENCE


define OTTOUPDATE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/otto-update $(TARGET_DIR)/usr/bin/
endef
$(eval $(cmake-package))
