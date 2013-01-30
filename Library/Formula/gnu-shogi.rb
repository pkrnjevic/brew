require 'formula'

class GnuShogi < Formula
  homepage 'http://www.cs.caltech.edu/~mvanier/hacking/gnushogi/gnushogi.html'
  url 'http://www.cs.caltech.edu/~mvanier/hacking/gnushogi/gnushogi-1.3.2.tar.gz'
  sha1 '6135ec3eb84917d0dc2cab9ac982818ed41aad87'

  depends_on :x11

  def patches
    # gcc 4.2.1 flags the following error
    # In file included from attacks.c:32:
    # gnushogi.h:144: error: conflicting types for ‘setlinebuf’
    # /usr/include/stdio.h:351: error: previous declaration of ‘setlinebuf’ was here
    #
    # My patch fixes this by changing the declared return type of setlinebuf in
    # gnushogi.h to int to match up with stdio.h's declaration
    # It was returning void anyway, so unless something errantly relies on it not
    # leaving something in the return register, this shouldn't break anything
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--x-include=#{MacOS::X11.include}",
                          "--x-lib=#{MacOS::X11.lib}"
    system "make"
    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end
end


__END__
diff --git a/gnushogi/gnushogi.h b/gnushogi/gnushogi.h
index 423a864..1d930c2 100644
--- a/gnushogi/gnushogi.h
+++ b/gnushogi/gnushogi.h
@@ -141,7 +141,7 @@ typedef unsigned long  ULONG;

 #ifdef HAVE_SETLINEBUF
 /* Not necessarily included in <stdio.h> */
-extern void setlinebuf(FILE *__stream);
+extern int setlinebuf(FILE *__stream);
 #endif

 #define RWA_ACC "r+"
