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
HOST_LLD_DEPENDENCIES = host-ninja host-llvm

HOST_LLD_CONF_OPTS += -GNinja
HOST_LLD_CONF_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
HOST_LLD_CONF_OPTS += -DCMAKE_C_FLAGS="${HOST_CFLAGS} -Wno-unused-local-typedefs -Wno-maybe-uninitialized -Wno-missing-field-initializers -Wno-unused-parameter -Wno-class-memaccess"
HOST_LLD_CONF_OPTS += -DCMAKE_CXX_FLAGS="${HOST_CXXFLAGS} -Wno-unused-local-typedefs -Wno-maybe-uninitialized -Wno-missing-field-initializers -Wno-unused-parameter -Wno-class-memaccess"

define HOST_LLD_BUILD_CMDS
	CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime \
	$(HOST_MAKE_ENV) ninja -j$(PARALLEL_JOBS) -c -C $(@D)/buildroot-build
endef

define HOST_LLD_INSTALL_CMDS
	$(HOST_MAKE_ENV) ninja -c -C $(@D)/buildroot-build install \
	strip $(HOST_DIR)/bin/*
endef

$(eval $(host-cmake-package))
