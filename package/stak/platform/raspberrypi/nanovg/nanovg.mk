#############################################################
#
# nanovg
#
#############################################################

NANOVG_VERSION = 90862ce25c
NANOVG_SITE = $(call github,NextThingCo,rtl81xxc,$(NANOVG_VERSION))
NANOVG_LICENSE = GPLv2
NANOVG_LICENSE_FILES = LICENCE
NANOVG_INSTALL_STAGING = YES
NANOVG_INSTALL_TARGET = NO


define NANOVG_BUILD_CMDS
	cd $(@D) ; premake4 gmake
	make CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/build config=debug nanovg
	#make -C $(@D)/build install
    #$(MAKE) GENIE="GENIE=../bx-$(BX_VERSION)/tools/bin/linux/genie" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) rpi-release
endef

define NANOVG_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/libnanovg.a $(STAGING_DIR)/usr/lib/libnanovg.a
	$(INSTALL) -D -m 0755 $(@D)/src/nanovg.h $(STAGING_DIR)/usr/include/nanovg.h
	$(INSTALL) -D -m 0755 $(@D)/src/nanovg_gl.h $(STAGING_DIR)/usr/include/nanovg_gl.h
	$(INSTALL) -D -m 0755 $(@D)/src/nanovg_gl_utils.h $(STAGING_DIR)/usr/include/nanovg_gl_utils.h
    # $(INSTALL) -D -m 0755 $(@D)/libarmmem.a $(STAGING_DIR)/usr/lib/libarmmem.a
endef

define NANOVG_INSTALL_TARGET_CMDS
    # $(INSTALL) -D -m 0755 $(@D)/libarmmem.a $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))