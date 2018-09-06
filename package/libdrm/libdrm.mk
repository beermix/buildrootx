################################################################################
#
# libdrm
#
################################################################################

LIBDRM_VERSION = 2.4.94
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = https://dri.freedesktop.org/libdrm
LIBDRM_LICENSE = MIT
LIBDRM_INSTALL_STAGING = YES

LIBDRM_DEPENDENCIES = \
	libpthread-stubs \
	host-pkgconf \
	host-meson \
	host-xutil_util-macros \
	libpciaccess

LIBDRM_CONF_OPTS = \
	-Dnouveau=false \
	-Domap=false \
	-Dexynos=false \
	-Dtegra=false \
	-Dlibkms=false \
	-Dcairo-tests=false \
	-Dman-pages=false \
	-Dvalgrind=false \
	-Dfreedreno-kgsl=false \
	-Dinstall-test-programs=false \
	-Dudev=false \
	-Dintel=true \
	-Dradeon=false \
	-Damdgpu=false \
	-Dvmwgfx=false \
	-Dvc4=false \
	-Dfreedreno=false \
	-Detnaviv=false

$(eval $(meson-package))