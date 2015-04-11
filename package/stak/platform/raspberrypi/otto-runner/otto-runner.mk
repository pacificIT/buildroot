#############################################################
#
# otto-runner
#
#############################################################

# OTTO_RUNNER_VERSION = 50165918b3d7d3764451db0b3b13cead2435e686
# OTTO_RUNNER_SITE = git@github.com:NextThingCo/otto-runner.git
# OTTO_RUNNER_SITE_METHOD = git

OTTO_RUNNER_SITE = /home/ubuntu/otto-runner
OTTO_RUNNER_SITE_METHOD = local

OTTO_RUNNER_LICENSE = GPLv2
OTTO_RUNNER_LICENSE_FILES = LICENCE
OTTO_RUNNER_CONF_OPTS = -DVC_SDK=$(STAGING_DIR)/opt/vc

define OTTO_RUNNER_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/otto-runner $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))
