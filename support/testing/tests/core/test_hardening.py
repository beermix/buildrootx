import os
import subprocess
import json

import infra.basetest

HARD_DEFCONFIG = \
    """
    BR2_powerpc64=y
    BR2_powerpc_e5500=y
    BR2_TOOLCHAIN_EXTERNAL=y
    BR2_TOOLCHAIN_EXTERNAL_DOWNLOAD=y
    BR2_TOOLCHAIN_EXTERNAL_URL="https://toolchains.bootlin.com/downloads/releases/toolchains/powerpc64-e5500/tarballs/powerpc64-e5500--glibc--stable-2018.02-2.tar.bz2"
    BR2_TOOLCHAIN_EXTERNAL_GCC_6=y
    BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_1=y
    BR2_TOOLCHAIN_EXTERNAL_CUSTOM_GLIBC=y
    BR2_TOOLCHAIN_EXTERNAL_CXX=y
    BR2_PACKAGE_LIGHTTPD=y
    BR2_PACKAGE_HOST_CHECKSEC=y
    # BR2_TARGET_ROOTFS_TAR is not set
    """

def checksec_run(builddir, target_file):
    cmd = ["host/bin/checksec", "--output", "json", "--file", target_file]
    ret = subprocess.check_output(cmd,
                                  stderr=open(os.devnull, "w"),
                                  cwd=builddir,
                                  env={"LANG": "C"})
    return ret

class TestRelro(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_RELRO_FULL=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertEqual(out["file"]["relro"], "full")
        self.assertEqual(out["file"]["pie"], "yes")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertEqual(out["file"]["relro"], "full")

class TestRelroPartial(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_RELRO_PARTIAL=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertEqual(out["file"]["relro"], "partial")
        self.assertEqual(out["file"]["pie"], "no")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertEqual(out["file"]["relro"], "partial")

class TestSspNone(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_SSP_NONE=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertEqual(out["file"]["canary"], "no")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertEqual(out["file"]["canary"], "no")


class TestSspStrong(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_SSP_STRONG=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertEqual(out["file"]["canary"], "yes")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertEqual(out["file"]["canary"], "yes")

class TestFortifyNone(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_FORTIFY_SOURCE_NONE=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertEqual(out["file"]["fortified"], "0")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertEqual(out["file"]["fortified"], "0")

class TestFortifyConserv(infra.basetest.BRTest):
    config = HARD_DEFCONFIG + \
        """
        BR2_FORTIFY_SOURCE_1=y
        """

    def test_run(self):
        out = json.loads(checksec_run(self.builddir, "target/usr/sbin/lighttpd"))
        self.assertNotEqual(out["file"]["fortified"], "0")
        out = json.loads(checksec_run(self.builddir, "target/bin/busybox"))
        self.assertNotEqual(out["file"]["fortified"], "0")
