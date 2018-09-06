################################################################################
#
# ninja
#
################################################################################

NINJA_VERSION = ca041d8
NINJA_SITE = $(call github,ninja-build,ninja,$(NINJA_VERSION))
NINJA_LICENSE = Apache-2.0
NINJA_LICENSE_FILES = COPYING

HOST_NINJA_DEPENDENCIES = host-python host-python3

define HOST_NINJA_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/bin/python2 ./configure.py --bootstrap; strip ./ninja)
endef

define HOST_NINJA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ninja $(HOST_DIR)/bin/ninja
sendef

$(eval $(host-generic-package))
