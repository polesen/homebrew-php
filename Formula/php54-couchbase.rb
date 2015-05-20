require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php54Couchbase < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/couchbase'
  url 'http://pecl.php.net/get/couchbase-2.0.7.tgz'
  sha1 '7c0f89a2f0a9ca2e0f7ed8a1b0b9bb601cc3f6aa'
  head 'https://github.com/couchbaselabs/php-couchbase.git'

  option 'with-igbinary', "Build with igbinary support"
  depends_on 'libcouchbase'
  depends_on 'php54-igbinary' if build.with? "igbinary"

  def install
    Dir.chdir "couchbase-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    args = []
    args << "--prefix=#{prefix}"
    args << phpconfig
    args << "--with-libcouchbase-dir=#{Formula['libcouchbase'].opt_prefix}"
    args << "--enable-couchbase-igbinary" if build.with? 'igbinary'

    safe_phpize

    if build.with? 'igbinary'
      system "mkdir -p ext/igbinary"
      cp "#{Formula['php54-igbinary'].opt_prefix}/include/igbinary.h", "ext/igbinary/igbinary.h"
    end

    system "./configure", *args
    system "make"
    prefix.install "modules/couchbase.so"
    write_config_file if build.with? "config-file"
  end
end
