################################################################################
#
# lapack
#
################################################################################

LAPACK_VERSION = 3.7.1
LAPACK_SOURCE = lapack-$(LAPACK_VERSION).tgz
LAPACK_LICENSE = BSD-3-Clause
LAPACK_LICENSE_FILES = LICENSE
LAPACK_SITE = http://www.netlib.org/lapack
LAPACK_INSTALL_STAGING = YES
LAPACK_SUPPORTS_IN_SOURCE_BUILD = NO
LAPACK_CONF_OPTS = -DLAPACKE=ON -DCBLAS=ON

HOST_LAPACK_CONF_OPTS += -GNinja
HOST_LAPACK_CONF_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

ifeq ($(BR2_PACKAGE_LAPACK_COMPLEX),y)
LAPACK_CONF_OPTS += -DBUILD_COMPLEX=ON -DBUILD_COMPLEX16=ON
else
LAPACK_CONF_OPTS += -DBUILD_COMPLEX=OFF -DBUILD_COMPLEX16=OFF
endif

define HOST_LAPACK_BUILD_CMDS
	$(HOST_MAKE_ENV) ninja -C $(@D)/buildroot-build -w dupbuild=err
endef

define HOST_LAPACK_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/buildroot-build install
endef

$(eval $(cmake-package))
$(eval $(host-cmake-package))
