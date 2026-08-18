class Ocb < Formula
  desc "OpenTelemetry Collector Builder - assemble custom OTel Collector distributions"
  homepage "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder"
  version "0.159.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_arm64"
      sha256 "789bb144707f4ba8e78ae905b4ece687e615f89107a32eee869bfdfb51865d5c"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_amd64"
      sha256 "4194f0adc28e6f5a6792ff88100143b54b0d1f8f6c0de32945b1e792e1cdd094"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_arm64"
      sha256 "47fcdda628b2e822fd3b98ec5efe80dbb5dd803c6a6d84c179403bf89131c0eb"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_amd64"
      sha256 "8f54ef07041637bbbdeceef2c678e4b2f04a620bf372f15fbf1f5b451e66794b"
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
