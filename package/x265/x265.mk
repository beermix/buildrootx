################################################################################
#
# x265
#
################################################################################

X265_VERSION = 2.8
X265_SOURCE = x265_$(X265_VERSION).tar.gz
X265_SITE = https://bitbucket.org/multicoreware/x265/downloads
X265_LICENSE = GPL-2.0+
X265_LICENSE_FILES = COPYING
X265_SUBDIR = source
X265_INSTALL_STAGING = YES

ifeq ($(BR2_i386)$(BR2_x86_64),y)
X265_DEPENDENCIES += host-nasm
endif

HOST_X265_CONF_OPTS += -GNinja
HOST_X265_CONF_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

X265_CONF_OPTS += -GNinja
X265_CONF_OPTS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# disable altivec, it has build issues
# https://bitbucket.org/multicoreware/x265/issues/320/
ifeq ($(BR2_powerpc64)$(BR2_powerpc64le),y)
X265_CONF_OPTS += -DENABLE_ALTIVEC=OFF
endif

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
X265_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_PIC=ON
else
X265_CONF_OPTS += -DENABLE_SHARED=OFF
endif

ifeq ($(BR2_PACKAGE_X265_CLI),y)
X265_CONF_OPTS += -DENABLE_CLI=ON
else
X265_CONF_OPTS += -DENABLE_CLI=OFF
endif

define HOST_X265_BUILD_CMDS
	$(HOST_MAKE_ENV) ninja -C $(@D)/source
endef

define HOST_X265_INSTALL_CMDS
	$(HOST_MAKE_ENV) ninja -C $(@D)/source install
endef

define X265_BUILD_CMDS
	$(MAKE_ENV) ninja -C $(@D)/source
endef

define X265_INSTALL_CMDS
	$(MAKE_ENV) ninja -C $(@D)/source install
endef

$(eval $(cmake-package))
$(eval $(host-cmake-package))