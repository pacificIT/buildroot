################################################################################
#
# glm
#
################################################################################

GLM_VERSION = e1c3c531dde218ca36ca53de4d279ad3ff525d64
GLM_SITE = $(call github,g-truc,glm,$(GLM_VERSION))
GLM_LICENSE = MIT
GLM_LICENSE_FILES = copying.txt

# GLM is a header-only library, it only makes sense
# to have it installed into the staging directory.
GLM_INSTALL_STAGING = YES
GLM_INSTALL_TARGET = NO

$(eval $(cmake-package))
