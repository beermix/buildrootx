################################################################################
#
# compilerrt
#
################################################################################

COMPILERRT_VERSION = 7.0.0rc2
#COMPILERRT_SITE = $(call github,llvm-mirror,compiler-rt,$(compilerrt_VERSION))
COMPILERRT_SITE = https://prereleases.llvm.org/7.0.0/rc2
COMPILERRT_SOURCE = compiler-rt-$(COMPILERRT_VERSION).src.tar.xz
COMPILERRT_LICENSE = NCSA
COMPILERRT_LICENSE_FILES = LICENSE.TXT
COMPILERRT_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_COMPILERRT_DEPENDENCIES = host-llvm

HOST_COMPILERRT_CONF_OPTS += \
		-DCMAKE_ASM_COMPILER=/bin/cc \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_CONFIG=$(HOST_DIR)/bin/llvm-config

define HOST_COMPILERRT_INSTALL_CMDS
     mkdir -p $(HOST_DIR)/usr/lib/clang/7.0.0/lib
     mkdir -p $(HOST_DIR)/usr/lib/clang/7.0.0/share
     cp -r $(HOST_DIR)/usr/lib/linux $(HOST_DIR)/usr/lib/clang/7.0.0/lib
     cp -r $(HOST_DIR)/share/*.txt $(HOST_DIR)/usr/lib/clang/7.0.0/share
endef

$(eval $(host-cmake-package))
