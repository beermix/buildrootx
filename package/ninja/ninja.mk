################################################################################
#
# ninja
#
################################################################################

NINJA_VERSION = ca041d8
NINJA_SITE = $(call github,ninja-build,ninja,$(NINJA_VERSION))
NINJA_LICENSE = Apache-2.0
NINJA_LICENSE_FILES = COPYING

HOST_NINJA_DEPENDENCIES = host-python host-python3 host-clang

define HOST_NINJA_BUILD_CMDS
	(cd $(@D); CXX=$(HOST_DIR)/bin/clang++ $(HOST_DIR)/bin/python2 ./configure.py --bootstrap; ./ninja ninja_test; ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots)
endef

define HOST_NINJA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ninja $(HOST_DIR)/bin/ninja
	strip $(HOST_DIR)/bin/ninja
endef

$(eval $(host-generic-package))
