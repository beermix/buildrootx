################################################################################
#
# pango
#
################################################################################

PANGO_VERSION_MAJOR = 1.42
PANGO_VERSION = $(PANGO_VERSION_MAJOR).1
PANGO_SOURCE = pango-$(PANGO_VERSION).tar.xz
PANGO_SITE = http://ftp.gnome.org/pub/GNOME/sources/pango/$(PANGO_VERSION_MAJOR)
PANGO_AUTORECONF = YES
PANGO_INSTALL_STAGING = YES
PANGO_LICENSE = LGPL-2.0+
PANGO_LICENSE_FILES = COPYING

PANGO_CONF_OPTS = -Denable_docs=false -Dgir=false
HOST_PANGO_CONF_OPTS = -Denable_docs=false -Dgir=false

PANGO_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	host-pkgconf \
	libglib2 \
	cairo \
	harfbuzz \
	fontconfig \
	freetype xlib_libXft xlib_libXrender libfribidi xlib_libX11
HOST_PANGO_DEPENDENCIES = \
	host-pkgconf \
	host-libglib2 \
	host-cairo \
	host-harfbuzz \
	host-fontconfig \
	host-freetype host-libfribidi

$(eval $(meson-package))
$(eval $(host-meson-package))
