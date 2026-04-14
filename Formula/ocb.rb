class Ocb < Formula
  desc "OpenTelemetry Collector Builder - assemble custom OTel Collector distributions"
  homepage "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder"
  version "0.150.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_arm64"
      sha256 "83a1d9ab91e65c72a4280c38b79709ec5bcf1df1a2fc62b96afef783ec28032c"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_amd64"
      sha256 "59d7e70e6d6566f507c3974df99b6416ab50a5cb2eba4ec3d7a72dcc37eddfe8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_arm64"
      sha256 "5de1020b3c2d3b1ccc001d3db984e72de75c22ad4e6a629b8a5362820da9f408"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_amd64"
      sha256 "377152923d0ce97fd14b14f8b11b1aaa151d4e64afe8976c31329173b62840e6"
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
