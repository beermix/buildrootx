################################################################################
#
# at-spi2-core
#
################################################################################

AT_SPI2_CORE_VERSION_MAJOR = 2.29.1
AT_SPI2_CORE_VERSION = $(AT_SPI2_CORE_VERSION_MAJOR).0
AT_SPI2_CORE_SOURCE = at-spi2-core-$(AT_SPI2_CORE_VERSION).tar.xz
AT_SPI2_CORE_SITE = http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/$(AT_SPI2_CORE_VERSION_MAJOR)
AT_SPI2_CORE_LICENSE = LGPL-2.0+
AT_SPI2_CORE_LICENSE_FILES = COPYING
AT_SPI2_CORE_INSTALL_STAGING = YES
AT_SPI2_CORE_DEPENDENCIES = host-pkgconf dbus libglib2 xlib_libXtst
AT_SPI2_CORE_CONF_OPTS = -Ddbus_daemon=/usr/bin/dbus-daemon

ATK_CONF_OPTS += \
	-Denable_docs=false \
	-Denable-introspection=no

ATK_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
ATK_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

$(eval $(meson-package))
