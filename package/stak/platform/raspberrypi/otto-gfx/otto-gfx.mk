#############################################################
#
# otto-gfx
#
#############################################################

OTTO_GFX_VERSION = be60bcdc67a07d74ac5cc6e4163d042df258c1c8
OTTO_GFX_SITE = git@github.com:NextThingCo/otto-gfx.git
OTTO_GFX_SITE_METHOD = git
OTTO_GFX_LICENSE = GPLv2
OTTO_GFX_LICENSE_FILES = LICENCE
OTTO_GFX_CONF_OPTS = -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard" -DVC_SDK=$(STAGING_DIR)/opt/vc
OTTO_GFX_INSTALL_STAGING = YES
OTTO_GFX_INSTALL_TARGET = YES

define OTTO_GFX_GIT_SUBMODULE_FIXUP
	git clone git@github.com:g-truc/glm.git $(@D)/deps/glm
	git clone git@github.com:memononen/nanosvg.git $(@D)/deps/nanosvg
endef

define OTTO_GFX_INSTALL_STAGING_CMDS
        $(INSTALL) -m 0644 $(@D)/libotto_gfx.so $(STAGING_DIR)/usr/lib
        $(INSTALL) -m 0644 $(@D)/src/*.hpp $(STAGING_DIR)/usr/include
        cp -rf $(@D)/deps/glm/glm/* $(STAGING_DIR)/usr/include
        cp -rf $(@D)/deps/nanosvg/src/* $(STAGING_DIR)/usr/include
endef

define OTTO_GFX_INSTALL_TARGET_CMDS
        $(INSTALL) -m 0644 $(@D)/libotto_gfx.so $(TARGET_DIR)/usr/lib
endef

OTTO_GFX_POST_DOWNLOAD_HOOKS += OTTO_GFX_GIT_SUBMODULE_FIXUP


$(eval $(cmake-package))
