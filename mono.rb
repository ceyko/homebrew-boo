require 'formula'

class Mono < Formula
  url 'http://download.mono-project.com/sources/mono/mono-2.10.9.tar.bz2'
  homepage 'http://www.mono-project.com/Release_Notes_Mono_2.10.9'
  sha1 '1a6e8c5a0c3d88d87982259aa04402e028a283de'

  option '32-bit', 'Build 32-bit'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      pthread_support.c:210:12: error: static declaration of 'pthread_setspecific' follows non-static declaration
      static int GC_setspecific (GC_key_t key, void *value) {
                 ^
      pthread_support.c:96:29: note: expanded from macro 'GC_setspecific'
      #     define GC_setspecific pthread_setspecific
                                  ^
      /usr/include/pthread.h:357:11: note: previous declaration is here
      int       pthread_setspecific(pthread_key_t ,
                ^
    EOS
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-glib=embedded
      --enable-nls=no
    ]

    args << '--host=x86_64-apple-darwin10' if MacOS.prefer_64_bit? unless build.include? '32-bit'

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/mono", "--version"
  end
end
