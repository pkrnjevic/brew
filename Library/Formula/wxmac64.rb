require 'formula'

class Wxmac64 < Formula
  # url 'http://sourceforge.net/projects/wxwindows/files/2.8.12/wxMac-2.8.12.tar.bz2'
  url 'http://sourceforge.net/projects/wxwindows/files/2.9.2/wxWidgets-2.9.2.tar.bz2'
  
  homepage 'http://www.wxwidgets.org'
  md5 'd6cec5bd331ba90b74c1e2fcb0563620'


  def install
    # Force x86_64
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch i386"
      ENV.append compiler_flag, "-arch x86_64"
    end

    # system "./configure", "--disable-debug", "--disable-dependency-tracking",
    #                       "--prefix=#{prefix}",
    #                       "--enable-unicode"
    system "./configure", "--disable-debug",
                      "--with-osx_cocoa",
                      "--prefix=#{prefix}",
                      "--enable-unicode",
                      "--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk", # Thanks over to our friends at https://trac.macports.org/ticket/30272
                      "--with-macosx-version-min=10.6", # also needed to fix "utils_osx.cpp:72: error: ‘CGDisplayBitsPerPixel’ was not declared in this scope"
                      "--with-opengl",
                      "--with-libjpeg",
                    "--with-libtiff",
                    "--with-libpng",
                    "--with-zlib",
                    "--enable-dnd",
                    "--enable-clipboard",
                    "--enable-webkit",
                    "--enable-svg",
                    "--with-expat"

    system "make install"

  end

  def caveats
    s = <<-EOS.undent
      wxWidgets 2.9.2 builds 64-bit only, so it should work with
      other Homebrew-installed softare on Snow Leopard (like Erlang).

    EOS

    return s
  end
end
