################################################################################
#
# jasper
#
################################################################################

JASPER_VERSION = version-2.0.14
JASPER_SITE = $(call github,mdadams,jasper,$(JASPER_VERSION))
JASPER_INSTALL_STAGING = YES
JASPER_LICENSE = JasPer License Version 2.0
JASPER_LICENSE_FILES = LICENSE
JASPER_SUPPORTS_IN_SOURCE_BUILD = NO
JASPER_DEPENDENCIES += jpeg-turbo
JASPER_CONF_OPTS = \
	-DCMAKE_DISABLE_FIND_PACKAGE_DOXYGEN=TRUE \
	-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=TRUE \
	-DJAS_ENABLE_SHARED=OFF \
	-DJAS_ENABLE_LIBJPEG=ON

$(eval $(cmake-package))
$(eval $(host-cmake-package))
