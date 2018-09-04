################################################################################
#
# lnav
#
################################################################################

LNAV_VERSION = def35d1
LNAV_SITE = $(call github,tstack,lnav,$(LNAV_VERSION))
LNAV_DEPENDENCIES = host-gettext libcurl bzip2 pcre libopenssl libssh2 lsqlite3 readline ncurses
LNAV_LICENSE = GPL-2.0+, LGPL-2.1+
LNAV_LICENSE_FILES = COPYING COPYING.LIB

$(eval $(autotools-package))
