################################################################################
#
# Chromium
#
################################################################################

CHROMIUM_VERSION = 67.0.3396.87
CHROMIUM_SITE = https://commondatastorage.googleapis.com/chromium-browser-official
CHROMIUM_SOURCE = chromium-$(CHROMIUM_VERSION).tar.xz
CHROMIUM_LICENSE = BSD-Style
CHROMIUM_LICENSE_FILES = LICENSE
CHROMIUM_DEPENDENCIES = host-yasm alsa-lib cairo systemd zlib dbus freetype harfbuzz \
			host-clang host-lld host-ninja host-python \
			jpeg-turbo libdrm libglib2 libkrb5 libnss libpng pango \
			pciutils xlib_libXcomposite xlib_libXScrnSaver \
			xlib_libXcursor xlib_libXrandr libva opus dbus-glib libxml2 libxslt cups

CHROMIUM_TOOLCHAIN_CONFIG_PATH = $(shell pwd)/package/chromium/toolchain

CHROMIUM_OPTS = \
	host_toolchain=\"$(CHROMIUM_TOOLCHAIN_CONFIG_PATH):host\" \
	custom_toolchain=\"$(CHROMIUM_TOOLCHAIN_CONFIG_PATH):target\" \
	use_lld=true \
	is_clang=true \
	clang_use_chrome_plugins=false \
	treat_warnings_as_errors=false \
	use_gnome_keyring=false \
	linux_use_bundled_binutils=false \
	use_sysroot=false \
	target_sysroot=\"$(STAGING_DIR)\" \
	target_cpu=\"$(BR2_PACKAGE_CHROMIUM_TARGET_ARCH)\" \
	google_api_key=\"AIzaSyAQ6L9vt9cnN4nM0weaa6Y38K4eyPvtKgI\" \
	google_default_client_id=\"740889307901-4bkm4e0udppnp1lradko85qsbnmkfq3b.apps.googleusercontent.com\" \
	google_default_client_secret=\"9TJlhL661hvShQub4cWhANXa\" \
	enable_nacl=false \
	use_dbus=true \
	use_cups=true \
	use_system_zlib=true \
	use_system_libjpeg=true \
	use_system_libpng=true \
	use_system_libdrm=true \
	use_system_harfbuzz=true \
	use_system_freetype=true \
	linux_link_libudev=true \
	symbol_level=0 \
	enable_webrtc=true \
	enable_hangout_services_extension=false \
	fatal_linker_warnings=false \
	fieldtrial_testing_like_official_build=true \
	enable_swiftshader=false \
	is_component_build=false \
	use_custom_libcxx=false \
	use_aura=true \
	ffmpeg_branding=\"Chrome\" \
	proprietary_codecs=true \
	enable_widevine=true \
	enable_vulkan=false \
	use_vaapi=true

# tcmalloc has portability issues
CHROMIUM_OPTS += use_allocator=\"none\"

# V8 snapshots require compiling V8 with the same word size as the target
# architecture, which means the host needs to have that toolchain available.
CHROMIUM_OPTS += v8_use_snapshot=false

ifeq ($(BR2_ENABLE_DEBUG),y)
CHROMIUM_OPTS += is_debug=true
else
CHROMIUM_OPTS += is_debug=false
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
CHROMIUM_DEPENDENCIES += pulseaudio
CHROMIUM_OPTS += use_pulseaudio=true
else
CHROMIUM_OPTS += use_pulseaudio=false
endif

ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
CHROMIUM_DEPENDENCIES += libgtk3
CHROMIUM_OPTS += use_gtk3=true
else
CHROMIUM_DEPENDENCIES += libgtk2 xlib_libXi xlib_libXtst
CHROMIUM_OPTS += use_gtk3=false
endif

ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
CHROMIUM_TARGET_LDFLAGS += --gcc-toolchain=$(TOOLCHAIN_EXTERNAL_INSTALL_DIR)
else
CHROMIUM_TARGET_LDFLAGS += --gcc-toolchain=$(HOST_DIR)
endif

CHROMIUM_TARGET_CFLAGS += $(CHROMIUM_TARGET_LDFLAGS)
CHROMIUM_TARGET_CXXFLAGS += $(CHROMIUM_TARGET_CFLAGS)

CHROMIUM_HOST_CFLAGS += --target=$(HOSTARCH)-buildroot-linux-gnu
CHROMIUM_HOST_CXXFLAGS += $(CHROMIUM_HOST_CFLAGS)
CHROMIUM_HOST_LDFLAGS += --gcc-toolchain="/usr"

define CHROMIUM_CONFIGURE_CMDS
export CCACHE_SLOPPINESS=time_macros
export CCACHE_COMPRESS=true
export CCACHE_COMPRESSLEVEL=7
	( cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/bin/python2 tools/gn/bootstrap/bootstrap.py -s --no-clean; \
		HOST_AR="$(HOSTAR)" \
		HOST_NM="$(HOSTNM)" \
		HOST_CC="ccache $(HOSTCC)" \
		HOST_CXX="ccache $(HOSTCXX)" \
		HOST_CFLAGS="$(HOST_CFLAGS)" \
		HOST_CXXFLAGS="$(HOST_CXXFLAGS)" \
		TARGET_AR="ar" \
		TARGET_NM="nm" \
		TARGET_CC="ccache clang" \
		TARGET_CXX="ccache clang++" \
		TARGET_CFLAGS="$(CHROMIUM_TARGET_CFLAGS) -fdiagnostics-color=always" \
		TARGET_CXXFLAGS="$(CHROMIUM_TARGET_CXXFLAGS) -fdiagnostics-color=always -fpermissive" \
		TARGET_CPPFLAGS="$(TARGET_CPPFLAGS)" \
		TARGET_LDFLAGS="$(CHROMIUM_TARGET_LDFLAGS)" \
		out/Release/gn gen out/Release --args="$(CHROMIUM_OPTS)" \
			--script-executable=$(HOST_DIR)/bin/python2 \
	)
endef

define CHROMIUM_BUILD_CMDS
	( cd $(@D); \
		$(TARGET_MAKE_ENV) \
		ninja -j$(PARALLEL_JOBS) -C out/Release chrome chrome_sandbox chromedriver \
	)
endef

define CHROMIUM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/out/Release/chrome $(TARGET_DIR)/usr/lib/chromium/chrome
	$(INSTALL) -Dm4755 $(@D)/out/Release/chrome_sandbox \
		$(TARGET_DIR)/usr/lib/chromium/chrome-sandbox
	cp $(@D)/out/Release/{chrome_{100,200}_percent,resources}.pak \
		$(@D)/out/Release/chromedriver \
		$(TARGET_DIR)/usr/lib/chromium/
	$(INSTALL) -Dm644 -t $(TARGET_DIR)/usr/lib/chromium/locales \
		$(@D)/out/Release/locales/*.pak
	cp $(@D)/out/Release/icudtl.dat $(TARGET_DIR)/usr/lib/chromium/
endef

$(eval $(generic-package))
