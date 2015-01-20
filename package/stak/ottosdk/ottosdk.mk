#############################################################
#
# ottosdk
#
#############################################################

OTTOSDK_VERSION = CES
# OTTOSDK_SITE = $(call github,NextThingCo,otto-sdk,$(OTTOSDK_VERSION))
OTTOSDK_SITE = file://$(TOPDIR)/package/stak/ottosdk
OTTOSDK_SOURCE = otto-sdk-$(OTTOSDK_VERSION).tar.gz
OTTOSDK_LICENSE = MIT
OTTOSDK_LICENSE_FILES = LICENCE
OTTOSDK_DEPENDENCIES = libbcm2835

#	TARGET_ENV = \
#		CC="$(TARGET_CC)" LD="$(TARGET_LD)" \
#	    LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/opt/vc/lib/" \
#	    INCLUDES="-I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/opt/vc/include -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/opt/vc/include/interface/vcos/pthreads"

#	define OTTOSDK_BUILD_CMDS
#	    $(TARGET_ENV) $(MAKE)  -C $(@D) all
#	endef

define OTTOSDK_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0755 $(@D)/stak-test $(STAGING_DIR)/usr/bin/stak-test
endef

define OTTOSDK_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/fastcmd
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk/assets
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk/fastcmd
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk/create_ap
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk/python
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/home/pi/otto-sdk/python/views

	$(INSTALL) -D -m 0755 $(@D)/main $(TARGET_DIR)/usr/bin

	$(INSTALL) -D -m 0755 $(@D)/fastcmd/* $(TARGET_DIR)/home/pi/fastcmd
	$(INSTALL) -D -m 0755 $(@D)/fastcmd/* $(TARGET_DIR)/home/pi/otto-sdk/fastcmd
	$(INSTALL) -D -m 0755 $(@D)/vendor/tools/create_ap/* $(TARGET_DIR)/home/pi/otto-sdk/create_ap
	$(INSTALL) -D -m 0755 $(@D)/python/server.py $(TARGET_DIR)/home/pi/otto-sdk/python
	$(INSTALL) -D -m 0755 $(@D)/python/views/* $(TARGET_DIR)/home/pi/otto-sdk/python/views

    $(INSTALL) -D -m 0755 $(@D)/assets/* $(TARGET_DIR)/home/pi/otto-sdk/assets
endef

$(eval $(generic-package))
