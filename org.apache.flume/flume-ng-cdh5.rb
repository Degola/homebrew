require 'formula'

class FlumeNgCdh5 < Formula
  homepage 'https://github.com/apache/flume'
  url 'http://archive.cloudera.com/cdh5/cdh/5/flume-ng-1.5.0-cdh5.3.0.tar.gz'
  version "1.5.0-cdh5.3.0"
  sha1 'a5259be8aea2ac01655183ca999daf23c61c42fc'

  def install
    system "mvn", "compile"
    libexec.install %w[bin conf lib]
    (bin/"flume-ng").write <<-EOS.undent
      #!/bin/bash
      export FLUME_CONF_DIR=${FLUME_CONF_DIR-#{libexec}/conf}
      exec #{libexec}/bin/flume-ng "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    See https://cwiki.apache.org/FLUME/getting-started.html for example configurations.
    Your flume config dir is #{libexec}/conf/
    If you intend to sink data to S3, you will need to download a missing JAR:
        wget -O #{libexec}/lib/jets3t-0.7.1.jar http://repo1.maven.org/maven2/net/java/dev/jets3t/jets3t/0.7.1/jets3t-0.7.1.jar
    EOS
  end

  def test
    system "#{bin}/flume-ng"
  end
end