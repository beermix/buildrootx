###############################################################################
#
# lld
#
###############################################################################

LLD_VERSION = 6.0.1
LLD_SITE = https://llvm.org/releases/$(LLD_VERSION)
LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
LLD_LICENSE = NCSA
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-python host-ninja

HOST_LLD_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
HOST_LLD_CONF_OPTS += -DPYTHON_EXECUTABLE=$(HOST_DIR)/bin/python2
HOST_LLD_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
HOST_LLD_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON
HOST_LLD_CONF_OPTS += -DLLVM_INCLUDE_TESTS=OFF
HOST_LLD_CONF_OPTS += -DLLVM_BUILD_TESTS=OFF
HOST_LLD_CONF_OPTS += -DLLVM_BUILD_DOCS=OFF

#HOST_LLD_CONF_OPTS += -GNinja
#HOST_LLD_CONF_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

#define HOST_LLD_BUILD_CMDS
#	( cd $(@D); \
#		$(HOST_MAKE_ENV) \
#		ninja -j$(PARALLEL_JOBS) -C buildroot-build
#	)
#endef

LLD_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))
$(eval $(host-cmake-package))