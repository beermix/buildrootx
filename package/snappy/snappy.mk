################################################################################
#
# snappy
#
################################################################################

SNAPPY_VERSION = 1.1.7
SNAPPY_SITE = $(call github,google,snappy,$(SNAPPY_VERSION))
SNAPPY_LICENSE = BSD-3-Clause
SNAPPY_LICENSE_FILES = COPYING
SNAPPY_INSTALL_STAGING = YES
SNAPPY_CONF_OPTS = -DSNAPPY_BUILD_TESTS=OFF -DBUILD_SHARED_LIBS=0

$(eval $(cmake-package))
