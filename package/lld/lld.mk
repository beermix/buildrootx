################################################################################
#
# lld
#
################################################################################

LLD_VERSION = 7.0.0
LLD_SITE = https://llvm.org/releases/$(LLD_VERSION)
LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
#LLD_VERSION = e36f4d4
#LLD_SITE = $(call github,llvm-mirror,lld,$(LLD_VERSION))
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm host-clang
# HOST_LLD_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime

$(eval $(host-cmake-package))
