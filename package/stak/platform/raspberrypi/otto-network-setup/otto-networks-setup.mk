#############################################################
#
# otto-network-setup
#
#############################################################

OTTO_NETWORK_SERVICE_VERSION = master
OTTO_NETWORK_SERVICE_SITE = $(call github,NextThingCo,otto-network-setup,$(OTTO_NETWORK_SERVICE_VERSION))
OTTDATE_INSTALL_TARGET = YES
OTTO_NETWORK_SERVICE_LICENSE = MIT
OTTO_NETWORK_SERVICE_LICENSE_FILES = LICENCE

define OTTO_NETWORK_SERVICE_INSTALL_INIT_SYSTEMD

	$(INSTALL) -D -m 755 $(@D)/otto-network-setup.py \
		$(TARGET_DIR)/usr/bin/otto-network-setup.py

	$(INSTALL) -D -m 644 $(@D)/setup.tpl \
		$(TARGET_DIR)/usr/lib/otto-network-setup/setup.tpl

	$(INSTALL) -D -m 644 $(@D)/jquery-1.11.2.min.js \
		$(TARGET_DIR)/usr/lib/otto-network-setup/query-1.11.2.min.js

	$(INSTALL) -D -m 644 $(@D)/bootstrap/js/bootstrap.js \
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/js/bootstrap.min.js
	
  $(INSTALL) -D -m 644 $(@D)/bootstrap/css/bootstrap.min.css \
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/css/bootstrap.min.css

  $(INSTALL) -D -m 644 $(@D)/bootstrap/fonts/glyphicons-halflings-regular.woff2
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/fonts/glyphicons-halflings-regular.woff2

  $(INSTALL) -D -m 644 $(@D)/bootstrap/fonts/glyphicons-halflings-regular.svg
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/fonts/glyphicons-halflings-regular.svg

  $(INSTALL) -D -m 644 $(@D)/bootstrap/fonts/glyphicons-halflings-regular.woff
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/fonts/glyphicons-halflings-regular.woff

  $(INSTALL) -D -m 644 $(@D)/bootstrap/fonts/glyphicons-halflings-regular.ttf
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/fonts/glyphicons-halflings-regular.ttf

  $(INSTALL) -D -m 644 $(@D)/bootstrap/fonts/glyphicons-halflings-regular.eot
		$(TARGET_DIR)/usr/lib/otto-network-setup/boostrap/fonts/glyphicons-halflings-regular.eot

	$(INSTALL) -D -m 644 $(@D)/otto-network-setup.service \
		$(TARGET_DIR)/usr/lib/systemd/system/otto-network-setup.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/otto-network-setup.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/otto-network-setup.service

endef

$(eval $(generic-package))
