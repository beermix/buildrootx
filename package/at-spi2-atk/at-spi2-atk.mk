################################################################################
#
# at-spi2-atk
#
################################################################################

AT_SPI2_ATK_VERSION_MAJOR = 2.29
AT_SPI2_ATK_VERSION = $(AT_SPI2_ATK_VERSION_MAJOR).1
AT_SPI2_ATK_SOURCE = at-spi2-atk-$(AT_SPI2_ATK_VERSION).tar.xz
AT_SPI2_ATK_SITE =  http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/$(AT_SPI2_ATK_VERSION_MAJOR)
AT_SPI2_ATK_LICENSE = LGPL-2.0+
AT_SPI2_ATK_LICENSE_FILES = COPYING
AT_SPI2_ATK_INSTALL_STAGING = YES
AT_SPI2_ATK_DEPENDENCIES = atk at-spi2-core libglib2 host-pkgconf libxml2
HOST_AT_SPI2_ATK_DEPENDENCIES = host-atk host-at-spi2-core host-libglib2 host-pkgconf host-libxml2

$(eval $(meson-package))
$(eval $(host-meson-package))