class Ocb < Formula
  desc "OpenTelemetry Collector Builder - assemble custom OTel Collector distributions"
  homepage "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder"
  version "0.152.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_arm64"
      sha256 "3565e8f5cca379edfaa0e353fe7affb45a10b832e2be65aeef22f95a3607c0a4"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_amd64"
      sha256 "dbc48830e02420be43d6d2f0937d97284c5cab160b88b83f1e09c7db1423de4b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_arm64"
      sha256 "cd8bda7c1221377e9bcd534f77d921c5ad72f89861640f47e2aaeae858b91076"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_amd64"
      sha256 "f051fedec367b376bb49ab025aae1fe443f21fe62b5465cbd8143c60c198d73c"
    end
  end

  livecheck do
    url :url
    regex(/^cmd\/builder\/v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |page|
      page.scan(regex).map { |match| match[0] }
    end
  end

  def install
    # The upstream binary is already named `ocb`, so we just install it directly.
    bin.install stable.url.split("/").last => "ocb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocb version")
  end
end
