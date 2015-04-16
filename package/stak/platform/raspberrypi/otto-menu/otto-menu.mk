#############################################################
#
# otto-menu
#
#############################################################

OTTO_MENU_SITE = /home/ubuntu/otto-menu
OTTO_MENU_SITE_METHOD = local
#   OTTO_MENU_VERSION = 90d5e3aceacdfd2c535008fb51a8e097cebebc4a
#   OTTO_MENU_SITE = git@github.com:NextThingCo/otto-menu.git
#   OTTO_MENU_SITE_METHOD = git
OTTO_MENU_LICENSE = GPLv2
OTTO_MENU_LICENSE_FILES = LICENCE
OTTO_MENU_INSTALL_STAGING = NO
OTTO_MENU_INSTALL_TARGET = YES
OTTO_MENU_CONF_OPTS =-DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -march=armv6 -mfloat-abi=hard" -DVC_SDK="$(STAGING_DIR)/opt/vc"

# define OTTO_MENU_GIT_SUBMODULE_FIXUP
# 	git clone git@github.com:sansumbrella/Choreograph.git $(@D)/deps/Choreograph
#   git clone git@github.com:alecthomas/entityx.git $(@D)/deps/entityx
#   git clone git@github.com:NextThingCo/otto-gfx.git $(@D)/deps/otto-gfx
#   git clone git@github.com:NextThingCo/otto-runner.git $(@D)/deps/otto-runner
# 	git clone git@github.com:NextThingCo/otto-utils.git $(@D)/deps/otto-utils
# endef

define OTTO_MENU_INSTALL_TARGET_CMDS
  $(INSTALL) -d 0644 $(TARGET_DIR)/stak/sdk
  $(INSTALL) -d 0644 $(TARGET_DIR)/stak/sdk/assets
  $(INSTALL) -m 0755 $(@D)/libotto_menu.so $(TARGET_DIR)/stak/sdk
  $(INSTALL) -m 0755 $(@D)/assets/* $(TARGET_DIR)/stak/sdk/assets
endef

# OTTO_MENU_POST_DOWNLOAD_HOOKS += OTTO_MENU_GIT_SUBMODULE_FIXUP


$(eval $(cmake-package))
