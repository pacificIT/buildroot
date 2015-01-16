#############################################################
#
# hostapdrtl
#
#############################################################

HOSTAPDRTL_VERSION = 1.0
HOSTAPDRTL_SITE = http://www.daveconroy.com/wp3/wp-content/uploads/2013/07/
HOSTAPDRTL_SOURCE = hostapd.zip
HOSTAPDRTL_LICENSE = GPLv2
HOSTAPDRTL_LICENSE_FILES = LICENCE
HOSTAPDRTL_INSTALL_STAGING = YES

define HOSTAPDRTL_EXTRACT_CMDS
	mkdir -p $(BUILD_DIR)/hostapdrtl-v$(HOSTAPDRTL_VERSION)
	unzip -d $(BUILD_DIR)/hostapdrtl-v$(HOSTAPDRTL_VERSION) $(DL_DIR)/$(HOSTAPDRTL_SOURCE)
	mv $(BUILD_DIR)/hostapdrtl-v$(HOSTAPDRTL_VERSION)/* $(@D)
	rmdir $(BUILD_DIR)/hostapdrtl-v$(HOSTAPDRTL_VERSION)
endef
define HOSTAPDRTL_INSTALL_TARGET_CMDS
	rm $(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -D -m 0755 $(@D)/hostapd $(TARGET_DIR)/usr/sbin/hostapd
endef

$(eval $(generic-package))