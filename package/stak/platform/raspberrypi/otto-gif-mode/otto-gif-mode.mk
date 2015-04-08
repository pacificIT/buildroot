#############################################################
#
# otto-menu
#
#############################################################

OTTO_GIF_MODE_VERSION = 7afccbb457659fef3e4bd65d4065024d35c3468f
OTTO_GIF_MODE_SITE = git@github.com:NextThingCo/otto-gif-mode.git
OTTO_GIF_MODE_SITE_METHOD = git
OTTO_GIF_MODE_LICENSE = GPLv2
OTTO_GIF_MODE_LICENSE_FILES = LICENCE
OTTO_GIF_MODE_CFLAGS = $(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard
OTTO_GIF_MODE_INSTALL_STAGING = NO
OTTO_GIF_MODE_INSTALL_TARGET = YES

define OTTO_GIF_MODE_GIT_SUBMODULE_FIXUP
	git clone git@github.com:sansumbrella/Choreograph.git $(@D)/deps/Choreograph
  git clone git@github.com:alecthomas/entityx.git $(@D)/deps/entityx
  git clone git@github.com:NextThingCo/otto-gfx.git $(@D)/deps/otto-gfx
  git clone git@github.com:NextThingCo/otto-runner.git $(@D)/deps/otto-runner
	git clone git@github.com:NextThingCo/otto-utils.git $(@D)/deps/otto-utils
endef

define OTTO_GIF_MODE_INSTALL_TARGET_CMDS
  $(INSTALL) -d 0644 $(TARGET_DIR)/stak/sdk
  $(INSTALL) -m 0755 $(@D)/libotto_gif_mode.so $(TARGET_DIR)/stak/sdk
endef

OTTO_GIF_MODE_POST_DOWNLOAD_HOOKS += OTTO_GIF_MODE_GIT_SUBMODULE_FIXUP


$(eval $(cmake-package))
