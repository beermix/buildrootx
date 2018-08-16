################################################################################
#
# lld
#
################################################################################

LLD_VERSION = 47f841f
LLD_SITE = $(call github,llvm-mirror,lld,$(LLD_VERSION))
#LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm

$(eval $(host-cmake-package))
