require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'http://ftpmirror.gnu.org/gmp/gmp-5.0.5.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.0.5.tar.bz2'
  sha256 '1f588aaccc41bb9aed946f9fe38521c26d8b290d003c5df807f65690f2aadec9'

  option '32-bit'

  def install
    # Reports of problems using gcc 4.0 on Leopard
    # https://github.com/mxcl/homebrew/issues/issue/2302
    # Also force use of 4.2 on 10.6 in case a user has changed the default
    # Do not force if xcode > 4.2 since it does not have /usr/bin/gcc-4.2 as default
    # FIXME convert this to appropriate fails_with annotations
    ENV.gcc if MacOS::Xcode.provides_gcc?

    args = %W[--prefix=#{prefix} --enable-cxx]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # see: http://gmplib.org/macos.html
    if MacOS.prefer_64_bit? and not build.build_32_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Doesn't install in parallel on 8-core Mac Pro
    # Upstream implores users to always run the test suite
    system "make check"
    system "make install"
  end
end
