################################################################################
#
# Chromium
#
################################################################################

CHROMIUM_VERSION = 68.0.3440.106
CHROMIUM_SITE = https://commondatastorage.googleapis.com/chromium-browser-official
CHROMIUM_SOURCE = chromium-$(CHROMIUM_VERSION).tar.xz
CHROMIUM_LICENSE = BSD-Style
CHROMIUM_LICENSE_FILES = LICENSE
CHROMIUM_DEPENDENCIES = alsa-lib cairo fontconfig freetype \
			harfbuzz host-clang host-ninja host-python \
			icu jpeg-turbo libdrm libglib2 libkrb5 libnss libpng \
			libxml2 libxslt opus pango snappy \
			xlib_libXcomposite xlib_libXScrnSaver xlib_libXcursor \
			xlib_libXrandr zlib libva systemd dbus

CHROMIUM_TOOLCHAIN_CONFIG_PATH = $(shell pwd)/package/chromium/toolchain

CHROMIUM_OPTS = \
	host_toolchain=\"$(CHROMIUM_TOOLCHAIN_CONFIG_PATH):host\" \
	custom_toolchain=\"$(CHROMIUM_TOOLCHAIN_CONFIG_PATH):target\" \
	v8_snapshot_toolchain=\"$(CHROMIUM_TOOLCHAIN_CONFIG_PATH):v8_snapshot\" \
	is_clang=true \
	use_vaapi=true \
	symbol_level=0 \
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
	enable_swiftshader=false \
	enable_linux_installer=false \
	is_official_build=true \
	use_system_harfbuzz=true \
	use_system_freetype=true \
	enable_vulkan=false \
	use_cfi_icall=false \
	fieldtrial_testing_like_official_build=true \
	enable_hangout_services_extension=true \
	enable_widevine=true \
	remove_webcore_debug_symbols=true \
	use_custom_libcxx=false

CHROMIUM_SYSTEM_LIBS = \
	fontconfig \
	freetype \
	harfbuzz-ng \
	icu \
	libdrm \
	libdrm

ifeq ($(BR2_i386)$(BR2_x86_64),y)
CHROMIUM_SYSTEM_LIBS += yasm
CHROMIUM_DEPENDENCIES += host-yasm
endif
# tcmalloc has portability issues
CHROMIUM_OPTS += use_allocator=\"none\"
ifeq ($(BR2_CCACHE),y)
CHROMIUM_CC_WRAPPER = ccache
endif

# LLD is unsupported on i386, and fails during linking
ifeq ($(BR2_i386)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
CHROMIUM_OPTS += use_lld=false
# Disable gold as well, to force usage of our toolchain's ld.bfd
CHROMIUM_OPTS += use_gold=false
else
CHROMIUM_DEPENDENCIES += host-lld
CHROMIUM_OPTS += use_lld=true
endif

# V8 snapshots require compiling V8 with the same word size as the target
# architecture, which means the host needs to have that toolchain available.
CHROMIUM_OPTS += v8_use_snapshot=false

ifeq ($(BR2_ENABLE_DEBUG),y)
CHROMIUM_OPTS += is_debug=true
else
CHROMIUM_OPTS += is_debug=false
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
CHROMIUM_DEPENDENCIES += cups
CHROMIUM_OPTS += use_cups=true
else
CHROMIUM_OPTS += use_cups=false
endif

ifeq ($(BR2_PACKAGE_CHROMIUM_PROPRIETARY_CODECS),y)
CHROMIUM_OPTS += proprietary_codecs=true ffmpeg_branding=\"Chrome\"
endif

ifeq ($(BR2_PACKAGE_PCIUTILS),y)
CHROMIUM_DEPENDENCIES += pciutils
CHROMIUM_OPTS += use_libpci=true
else
CHROMIUM_OPTS += use_libpci=false
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

define CHROMIUM_CONFIGURE_CMDS
	# Allow building against system libraries in official builds
	( cd $(@D); \
		sed -i 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
			tools/generate_shim_headers/generate_shim_headers.py \
	)

	# Use python2 by default
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/usr/bin/python2 $(@D)/bin/python

	( cd $(@D); \
		for _lib in $(CHROMIUM_SYSTEM_LIBS); do \
			find "third_party/$$_lib" -type f \
			  \! -path "third_party/$$_lib/chromium/*" \
			  \! -path "third_party/$$_lib/google/*" \
			  \! -path "third_party/yasm/run_yasm.py" \
			  \! -regex '.*\.\(gn\|gni\|isolate\)' \
			  -delete; \
		done \
	)
	( cd $(@D); \
		$(TARGET_MAKE_ENV) \
		build/linux/unbundle/replace_gn_files.py \
			--system-libraries $(CHROMIUM_SYSTEM_LIBS) \
	)

	( cd $(@D); \
		$(TARGET_MAKE_ENV) \
		CCACHE_SLOPPINESS=time_macros \
		CCACHE_NOSTATS=1 \
		AR="$(HOSTAR)" \
		CC="$(HOSTCC)" \
		CXX="$(HOSTCXX)" \
		$(HOST_DIR)/bin/python2 tools/gn/bootstrap/bootstrap.py -s --no-clean; \
		HOST_AR="$(HOSTAR)" \
		HOST_CC="$(HOSTCC)" \
		HOST_CFLAGS="$(HOST_CFLAGS)" \
		HOST_CXX="$(HOSTCXX)" \
		HOST_CXXFLAGS="$(HOST_CXXFLAGS)" \
		HOST_NM="$(HOSTNM)" \
		TARGET_AR="ar" \
		TARGET_CC="$(CHROMIUM_CC_WRAPPER) clang" \
		TARGET_CFLAGS="$(CHROMIUM_TARGET_CFLAGS) -Wno-builtin-macro-redefined -fno-unwind-tables -fno-asynchronous-unwind-tables" \
		TARGET_CXX="$(CHROMIUM_CC_WRAPPER) clang++" \
		TARGET_CXXFLAGS="$(CHROMIUM_TARGET_CXXFLAGS) -Wno-builtin-macro-redefined -fno-unwind-tables -fno-asynchronous-unwind-tables" \
		TARGET_CPPFLAGS="$(CHROMIUM_TARGET_CPPFLAGS) -D__DATE__=  -D__TIME__=  -D__TIMESTAMP__=  -DNO_UNWIND_TABLES" \
		TARGET_LDFLAGS="$(CHROMIUM_TARGET_LDFLAGS)" \
		TARGET_NM="nm" \
		V8_AR="$(HOSTAR)" \
		V8_CC="$(CHROMIUM_CC_WRAPPER) clang" \
		V8_CXX="$(CHROMIUM_CC_WRAPPER) clang++" \
		V8_NM="$(HOSTNM)" \
		out/Release/gn gen out/Release --args="$(CHROMIUM_OPTS)" \
			--script-executable=$(HOST_DIR)/bin/python2 \
	)
endef

define CHROMIUM_BUILD_CMDS
	( cd $(@D); \
		$(TARGET_MAKE_ENV) \
		PATH=$(@D)/bin:$(BR_PATH) \
		ninja -j$(PARALLEL_JOBS) -C out/Release chrome chrome_sandbox chromedriver \
	)
endef

define CHROMIUM_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/out/Release/chrome $(TARGET_DIR)/usr/lib/chromium/chromium.bin
	$(INSTALL) -Dm4755 $(@D)/out/Release/chrome_sandbox \
		$(TARGET_DIR)/usr/lib/chromium/chrome-sandbox
	cp $(@D)/out/Release/{chrome_{100,200}_percent,resources}.pak \
		$(@D)/out/Release/chromedriver \
		$(TARGET_DIR)/usr/lib/chromium/
	$(INSTALL) -Dm644 -t $(TARGET_DIR)/usr/lib/chromium/locales \
		$(@D)/out/Release/locales/*.pak
	cp $(@D)/out/Release/icudtl.dat $(TARGET_DIR)/usr/lib/chromium/

	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/chromium/chrome
	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/chromium/chromedriver
endef

$(eval $(generic-package))
