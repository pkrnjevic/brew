require 'formula'

class Jhead < Formula
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  url 'http://www.sentex.net/~mwandel/jhead/jhead-3.00.tar.gz'
  sha1 '6bd3faa38cc884b5370e8e8f15bc10cbb706ec7a'

  def install
    system "make"
    bin.install "jhead"
    man1.install 'jhead.1'
    doc.install 'usage.html'
  end
end
