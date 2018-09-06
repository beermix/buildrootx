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

#LIBGLIB2_INSTALL_STAGING = YES
#LIBGLIB2_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

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
	host-pkgconf host-meson \
	libffi pcre util-linux zlib $(TARGET_NLS_DEPENDENCIES)

HOST_LIBGLIB2_DEPENDENCIES = \
	host-gettext \
	host-meson \
	host-libffi \
	host-pcre \
	host-pkgconf \
	host-util-linux \
	host-zlib

# Purge gdb-related files
ifneq ($(BR2_PACKAGE_GDB),y)
define LIBGLIB2_REMOVE_GDB_FILES
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gdb
endef
endif

# Purge useless binaries from target
define LIBGLIB2_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/glib-2.0
	rm -rf $(addprefix $(TARGET_DIR)/usr/share/glib-2.0/,codegen gettext)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gdbus-codegen glib-compile-schemas glib-compile-resources glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
	$(LIBGLIB2_REMOVE_GDB_FILES)
endef

LIBGLIB2_POST_INSTALL_TARGET_HOOKS += LIBGLIB2_REMOVE_DEV_FILES

# Remove schema sources/DTDs, we use staging ones to compile them.
# Do so at target finalization since other packages install additional
# ones and we want to deal with it in a single place.
define LIBGLIB2_REMOVE_TARGET_SCHEMAS
	rm -f $(TARGET_DIR)/usr/share/glib-2.0/schemas/*.xml \
		$(TARGET_DIR)/usr/share/glib-2.0/schemas/*.dtd
endef

# Compile schemas at target finalization since other packages install
# them as well, and better do it in a central place.
# It's used at run time so it doesn't matter defering it.
define LIBGLIB2_COMPILE_SCHEMAS
	$(HOST_DIR)/bin/glib-compile-schemas \
		$(STAGING_DIR)/usr/share/glib-2.0/schemas \
		--targetdir=$(TARGET_DIR)/usr/share/glib-2.0/schemas
endef

LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_REMOVE_TARGET_SCHEMAS
LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_COMPILE_SCHEMAS

# Purge gdb-related files
ifneq ($(BR2_PACKAGE_GDB),y)
define LIBGLIB2_REMOVE_GDB_FILES
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gdb
endef
endif

# Purge useless binaries from target
define LIBGLIB2_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/glib-2.0
	rm -rf $(addprefix $(TARGET_DIR)/usr/share/glib-2.0/,codegen gettext)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gdbus-codegen glib-compile-schemas glib-compile-resources glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
	$(LIBGLIB2_REMOVE_GDB_FILES)
endef

LIBGLIB2_POST_INSTALL_TARGET_HOOKS += LIBGLIB2_REMOVE_DEV_FILES

# Remove schema sources/DTDs, we use staging ones to compile them.
# Do so at target finalization since other packages install additional
# ones and we want to deal with it in a single place.
define LIBGLIB2_REMOVE_TARGET_SCHEMAS
	rm -f $(TARGET_DIR)/usr/share/glib-2.0/schemas/*.xml \
		$(TARGET_DIR)/usr/share/glib-2.0/schemas/*.dtd
endef

# Compile schemas at target finalization since other packages install
# them as well, and better do it in a central place.
# It's used at run time so it doesn't matter defering it.
define LIBGLIB2_COMPILE_SCHEMAS
	$(HOST_DIR)/bin/glib-compile-schemas \
		$(STAGING_DIR)/usr/share/glib-2.0/schemas \
		--targetdir=$(TARGET_DIR)/usr/share/glib-2.0/schemas
endef

LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_REMOVE_TARGET_SCHEMAS
LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_COMPILE_SCHEMAS

$(eval $(meson-package))
$(eval $(host-meson-package))

LIBGLIB2_HOST_BINARY = $(HOST_DIR)/bin/glib-genmarshal
