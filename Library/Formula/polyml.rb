require 'formula'

class Polyml < Formula
  homepage 'http://www.polyml.org'
  url 'http://downloads.sourceforge.net/project/polyml/polyml/5.3/polyml.5.3.tar.gz'
  sha1 'a037cd8cf4ce4a43b685b0e0d80f3f1e20d7c9fa'

  def install
    # for whatever reason, the configure script fails to find c++ if CXX is defined.
    # this overrides configure so that it won't check for c++ and will assume it exists.
    ENV["check_cpp"] = "yes"
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
