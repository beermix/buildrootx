################################################################################
#
# compilerrt
#
################################################################################  -DCMAKE_BUILD_TYPE:STRING=Release

#compilerrt_VERSION = 6.0.1
#compilerrt_SITE = https://llvm.org/releases/$(compilerrt_VERSION)
#compilerrt_SOURCE = compiler-rt-$(compilerrt_VERSION).src.tar.xz

COMPILERRT_VERSION = 7.0.0rc2
#COMPILERRT_SITE = $(call github,llvm-mirror,compiler-rt,$(compilerrt_VERSION))
COMPILERRT_SITE = https://prereleases.llvm.org/7.0.0/rc2
COMPILERRT_SOURCE = compiler-rt-$(COMPILERRT_VERSION).src.tar.xz
COMPILERRT_LICENSE = NCSA
COMPILERRT_LICENSE_FILES = LICENSE.TXT
COMPILERRT_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_COMPILERRT_DEPENDENCIES = host-llvm

HOST_COMPILERRT_CONF_OPTS += \
		-DCOMPILER_RT_INCLUDE_TESTS=OFF \
		-DCMAKE_ASM_COMPILER=$(HOSTCC) \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DLLVM_CONFIG:FILEPATH=$(HOST_DIR)/bin/llvm-config

$(eval $(host-cmake-package))
