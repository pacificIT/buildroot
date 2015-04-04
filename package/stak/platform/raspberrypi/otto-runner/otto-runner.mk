#############################################################
#
# otto-runner
#
#############################################################

OTTO_RUNNER_VERSION = 1d361e7be3047e6efa42cb243de78d883c6c1dc6
OTTO_RUNNER_SITE = git@github.com:NextThingCo/otto-runner.git
OTTO_RUNNER_SITE_METHOD = git
OTTO_RUNNER_LICENSE = GPLv2
OTTO_RUNNER_LICENSE_FILES = LICENCE


define OTTO_RUNNER_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/otto-runner $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))
