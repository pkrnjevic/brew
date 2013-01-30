require 'formula'

class Scheme48 < Formula
  homepage 'http://www.s48.org/'
  url 'http://www.s48.org/1.8/scheme48-1.8.tgz'
  sha1 '75299fe9de4bf239fc1d5a7dfa2ec377e0e98df1'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gc=bibop"
    system "make"
    system "make install"
  end
end
