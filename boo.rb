require 'formula'

class Boo < Formula
  homepage 'http://boo.codehaus.org/'
  url 'http://dist.codehaus.org/boo/distributions/boo-0.9.4.9-bin.zip'
  sha1 'fccaf3b99b427e9bb14b1fc68d30c8c4d44bc05b'

  depends_on 'mono'

  # Return wrapper script to set mono path to boo libraries.
  def mono_exec(name)
    <<-EOS.undent
      #!/bin/sh
      MONO_PATH=$MONO_PATH:#{libexec}/lib /usr/local/bin/mono "#{libexec}/bin/#{name}.exe" "$@"
    EOS
  end

  def install
    # install wrapper scripts for executables
    Dir['bin/*.exe'].each do |file|
      fn = File.basename(file, '.exe')
      (bin+fn).write mono_exec(fn)
    end

    # install executables, libraries
    cd 'bin' do
      (libexec+'lib').install Dir['*.dll']
      (libexec+'bin').install Dir['boo.*','booc.*','booi.*','booish.*']
    end

    # install docs
    doc.install Dir['docs/*']
    (doc+'examples').install Dir['examples/*']
  end

  def test
    system "#{bin}/boo", "-help"
  end
end
