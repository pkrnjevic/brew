require 'formula'

class Fceux < Formula
  homepage 'http://fceux.com'
  url 'http://downloads.sourceforge.net/fceultra/fceux-2.1.5.src.tar.bz2'
  sha1 '599ef6a261ab1bd24e58468886d7cc303e150feb'

  option 'no-gtk', "Build without Gtk+ support"

  depends_on 'scons' => :build
  depends_on 'sdl'
  depends_on 'libzip'
  depends_on 'gtk+' unless build.include? "no-gtk"
  depends_on :x11

  # fixes compilation errors on osx; upstream in 2.1.6
  def patches; DATA; end

  def install
    if build.include? "no-gtk"
      inreplace "SConstruct",
        "BoolVariable('GTK', 'Enable GTK2 GUI (SDL only)', 1),",
        "BoolVariable('GTK', 'Enable GTK2 GUI (SDL only)', 0),"
    end

    system "scons"
    bin.install 'src/fceux'
  end
end


__END__
t a/src/drivers/sdl/SConscript b/src/drivers/sdl/SConscript
index 9c7247c..7a9f297 100644
--- a/src/drivers/sdl/SConscript
+++ b/src/drivers/sdl/SConscript
@@ -1,3 +1,6 @@
+Import('env')
+env.ParseConfig('pkg-config --cflags --libs x11')
+Export('env')
 my_list =  Split("""
 input.cpp
 config.cpp
# config.cpp
