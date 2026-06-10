class Ocb < Formula
  desc "OpenTelemetry Collector Builder - assemble custom OTel Collector distributions"
  homepage "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder"
  version "0.154.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_arm64"
      sha256 "829e06a46f544f12fabc98739b9a134bf87627763c7a07a77c974e71db714e48"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_amd64"
      sha256 "41274a7581c7c0d3a8f377afd2b37772b0ef4d37a17daaf7ecfe75d2786603c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_arm64"
      sha256 "6993ebc7938df23e427362b8d8ac82021c2952d5a79bbfc83a1690a72e110e73"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_amd64"
      sha256 "8903bdc68dd8f40555615b0e0f0aa4c1b56c14e1f6f3e20c64f6c4cb32848365"
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
