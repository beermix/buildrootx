################################################################################
#
# lld
#
################################################################################

LLD_VERSION = 6.0.1
LLD_SITE = https://llvm.org/releases/$(LLD_VERSION)
LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm

HOST_LLD_CONF_OPTS += \
	-DCMAKE_BUILD_TYPE=Release \
	-DPYTHON_EXECUTABLE=$(HOST_DIR)/usr/bin/python2 \
	-DBUILD_SHARED_LIBS=OFF \
	-DLLVM_LINK_LLVM_DYLIB=ON \
	-DLLVM_INCLUDE_TESTS=ON \
	-DLLVM_BUILD_TESTS=ON \
	-DLLVM_BUILD_DOCS=OFF

$(eval $(host-cmake-package))
