require 'formula'

class RomTools < Formula
  homepage 'http://www.mess.org/'
  url 'svn://dspnet.fr/mame/trunk', :revision => 17961
  version '0.147'

  head 'svn://dspnet.fr/mame/trunk'

  depends_on :x11
  depends_on 'sdl'

  def install
    ENV['MACOSX_USE_LIBSDL'] = '1'
    ENV['INCPATH'] = "-I./src/lib/util -I#{MacOS::X11.include}"
    ENV['PTR64'] = (MacOS.prefer_64_bit? ? '1' : '0')

    system 'make romcmp'
    system 'make jedutil'
    system 'make chdman'
    system 'make tools'

    bin.install %W[
      castool chdman floptool imgtool jedutil ldresample ldverify regreg
      romcmp src2htm srcclean testkeys unidasm
    ]
    bin.install 'split' => 'rom-split'
  end
end
