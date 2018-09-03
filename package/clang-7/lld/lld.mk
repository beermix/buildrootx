################################################################################
#
# lld
#
################################################################################

LLD_VERSION = f44c9f4
LLD_SITE = $(call github,llvm-mirror,lld,$(LLD_VERSION))
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm
HOST_LLD_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

$(eval $(host-cmake-package))
