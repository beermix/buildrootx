################################################################################
#
# libglib2
#
################################################################################

LIBGLIB2_VERSION_MAJOR = 2.58
LIBGLIB2_VERSION = $(LIBGLIB2_VERSION_MAJOR).0
LIBGLIB2_SOURCE = glib-$(LIBGLIB2_VERSION).tar.xz
LIBGLIB2_SITE = http://ftp.gnome.org/pub/gnome/sources/glib/$(LIBGLIB2_VERSION_MAJOR)
LIBGLIB2_LICENSE = LGPL-2.1+
LIBGLIB2_LICENSE_FILES = COPYING

HOST_LIBGLIB2_CONF_OPTS = \
	-Dselinux=false \
	-Dlibmount=false \
	-Dinternal_pcre=false \
	-Dxattr=false \
	-Dman=false \
	-Ddtrace=false \
	-Dinstalled_tests=false \
	-Dforce_posix_threads=true \
	-Dgtk_doc=false
	
LIBGLIB2_CONF_OPTS = \
	-Dselinux=false \
	-Dlibmount=false \
	-Dinternal_pcre=false \
	-Dxattr=false \
	-Dman=false \
	-Ddtrace=false \
	-Dinstalled_tests=false \
	-Dforce_posix_threads=true \
	-Dgtk_doc=false
	
LIBGLIB2_DEPENDENCIES = \
	host-pkgconf host-meson host-libglib2 \
	libffi pcre util-linux zlib $(TARGET_NLS_DEPENDENCIES)

HOST_LIBGLIB2_DEPENDENCIES = \
	host-gettext \
	host-meson \
	host-libffi \
	host-pcre \
	host-pkgconf \
	host-util-linux \
	host-zlib

$(eval $(meson-package))
$(eval $(host-meson-package))
