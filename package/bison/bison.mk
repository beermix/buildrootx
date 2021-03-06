################################################################################
#
# bison
#
################################################################################

BISON_VERSION = 3.1
BISON_SOURCE = bison-$(BISON_VERSION).tar.xz
BISON_SITE = $(BR2_GNU_MIRROR)/bison
BISON_LICENSE = GPL-3.0+
BISON_LICENSE_FILES = COPYING
HOST_BISON_DEPENDENCIES = host-m4 host-automake host-gettext

$(eval $(host-autotools-package))
