require 'formula'

class Rtmpdump < Formula
  homepage 'http://rtmpdump.mplayerhq.hu'
  url 'http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz'
  sha1 'b65ce7708ae79adb51d1f43dd0b6d987076d7c42'

  head 'git://git.ffmpeg.org/rtmpdump'

  depends_on 'openssl' if MacOS.version == :leopard

  fails_with :llvm do
    build '2336'
    cause "Crashes at runtime"
  end

  # Use dylib instead of so
  def patches; DATA; end unless build.head?

  def install
    ENV.deparallelize
    sys_type = build.head? ? "darwin" : "posix"
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{sys_type}",
                   "prefix=#{prefix}",
                   "install"
  end
end

__END__
--- rtmpdump-2.3/librtmp/Makefile.orig	2010-07-30 23:05:25.000000000 +0200
+++ rtmpdump-2.3/librtmp/Makefile	2010-07-30 23:08:23.000000000 +0200
@@ -25,7 +25,7 @@
 CRYPTO_REQ=$(REQ_$(CRYPTO))
 CRYPTO_DEF=$(DEF_$(CRYPTO))
 
-SO_posix=so.0
+SO_posix=dylib
 SO_mingw=dll
 SO_EXT=$(SO_$(SYS))
 
@@ -61,7 +61,7 @@
 	$(AR) rs $@ $?
 
 librtmp.$(SO_EXT): $(OBJS)
-	$(CC) -shared -Wl,-soname,$@ $(LDFLAGS) -o $@ $^ $> $(CRYPTO_LIB)
+	$(CC) -shared $(LDFLAGS) -o $@ $^ $> $(CRYPTO_LIB)
 	ln -sf $@ librtmp.so
 
 log.o: log.c log.h Makefile
@@ -87,5 +87,8 @@
 	cp librtmp.so.0 $(LIBDIR)
 	cd $(LIBDIR); ln -sf librtmp.so.0 librtmp.so
 
+install_dylib:	librtmp.dylib
+	cp librtmp.dylib $(LIBDIR)
+
 install_dll:	librtmp.dll
 	cp librtmp.dll $(BINDIR)

