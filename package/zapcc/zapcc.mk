################################################################################
#
# zapcc
#
################################################################################

ZAPCC_VERSION = f23c9ba
ZAPCC_SITE = $(call github,yrnkrn,zapcc,$(ZAPCC_VERSION))
ZAPCC_SUPPORTS_IN_SOURCE_BUILD = NO
ZAPCC_INSTALL_STAGING = YES

HOST_ZAPCC_DEPENDENCIES = host-llvm host-libxml2
ZAPCC_DEPENDENCIES = llvm host-zapcc

# This option is needed, otherwise multiple shared libs
# (libclangAST.so, libclangBasic.so, libclangFrontend.so, etc.) will
# be generated. As a final shared lib containing all these components
# (libclang.so) is also generated, this resulted in the following
# error when trying to use tools that use libclang:
# $ CommandLine Error: Option 'track-memory' registered more than once!
# $ LLVM ERROR: inconsistency in registered CommandLine options
# By setting BUILD_SHARED_LIBS to OFF, we generate multiple static
# libraries (the same way as host's clang build) and finally
# libclang.so to be installed on the target.
ZAPCC_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

# Default is Debug build, which requires considerably more disk space
# and build time. Release build is selected for host and target
# because the linker can run out of memory in Debug mode.
HOST_ZAPCC_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
ZAPCC_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

ZAPCC_CONF_OPTS += -DCMAKE_CROSSCOMPILING=1

# We need to build tools because libclang is a tool
HOST_ZAPCC_CONF_OPTS += -DZAPCC_BUILD_TOOLS=ON
ZAPCC_CONF_OPTS += -DZAPCC_BUILD_TOOLS=ON

HOST_ZAPCC_CONF_OPTS += \
	-DZAPCC_BUILD_EXAMPLES=OFF \
	-DZAPCC_INCLUDE_DOCS=OFF \
	-DZAPCC_INCLUDE_TESTS=OFF

ZAPCC_CONF_OPTS += \
	-DZAPCC_BUILD_EXAMPLES=OFF \
	-DZAPCC_INCLUDE_DOCS=OFF \
	-DZAPCC_INCLUDE_TESTS=OFF

HOST_ZAPCC_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(HOST_DIR)/bin/llvm-config
ZAPCC_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(STAGING_DIR)/usr/bin/llvm-config \
	-DZAPCC_TABLEGEN:FILEPATH=$(HOST_DIR)/usr/bin/clang-tblgen \
	-DLLVM_TABLEGEN_EXE:FILEPATH=$(HOST_DIR)/usr/bin/llvm-tblgen

# Clang can't be used as compiler on the target since there are no
# development files (headers) and other build tools. So remove clang
# binaries and some other unnecessary files from target.
ZAPCC_FILES_TO_REMOVE = \
	/usr/bin/zapcc* \
	/usr/bin/c-index-test \
	/usr/bin/git-zapcc-format \
	/usr/bin/scan-build \
	/usr/bin/scan-view \
	/usr/libexec/c++-analyzer \
	/usr/libexec/ccc-analyzer \
	/usr/share/zapcc \
	/usr/share/opt-viewer \
	/usr/share/scan-build \
	/usr/share/scan-view \
	/usr/share/man/man1/scan-build.1 \
	/usr/lib/zapcc

define ZAPCC_CLEANUP_TARGET
	rm -rf $(addprefix $(TARGET_DIR),$(ZAPCC_FILES_TO_REMOVE))
endef
ZAPCC_POST_INSTALL_TARGET_HOOKS += ZAPCC_CLEANUP_TARGET

# clang-tblgen is not installed by default, however it is necessary
# for cross-compiling clang
define HOST_ZAPCC_INSTALL_ZAPCC_TBLGEN
	$(INSTALL) -D -m 0755 $(HOST_ZAPCC_BUILDDIR)/bin/clang-tblgen \
		$(HOST_DIR)/usr/bin/zapcc-tblgen
endef
HOST_ZAPCC_POST_INSTALL_HOOKS = HOST_ZAPCC_INSTALL_ZAPCC_TBLGEN

# This option must be enabled to link libclang dynamically against libLLVM.so
HOST_ZAPCC_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON
ZAPCC_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON

# Prevent clang binaries from linking against LLVM static libs
HOST_ZAPCC_CONF_OPTS += -DLLVM_DYLIB_COMPONENTS=all
ZAPCC_CONF_OPTS += -DLLVM_DYLIB_COMPONENTS=all

$(eval $(cmake-package))
$(eval $(host-cmake-package))
