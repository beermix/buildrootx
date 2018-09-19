################################################################################
#
# opus
#
################################################################################

OPUS_VERSION = 1.2.1
OPUS_SITE = https://downloads.xiph.org/releases/opus
OPUS_LICENSE = BSD-3-Clause
OPUS_LICENSE_FILES = COPYING
OPUS_INSTALL_STAGING = YES
OPUS_CONF_OPTS += --disable-shared --enable-static

ifeq ($(BR2_PACKAGE_OPUS_FIXED_POINT),y)
OPUS_CONF_OPTS += --enable-fixed-point
endif

TARGET_OPUS_MAKE_OPTS = \
        $(HOST_CONFIGURE_OPTS) \
        CFLAGS="$(HOST_CFLAGS) -fPIC"

# When we're on ARM, but we don't have ARM instructions (only
# Thumb-2), disable the usage of assembly as it is not Thumb-ready.
ifeq ($(BR2_arm)$(BR2_armeb):$(BR2_ARM_CPU_HAS_ARM),y:)
OPUS_CONF_OPTS += --disable-asm
endif

$(eval $(autotools-package))
