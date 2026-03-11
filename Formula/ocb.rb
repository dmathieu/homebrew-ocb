class Ocb < Formula
  desc "OpenTelemetry Collector Builder - assemble custom OTel Collector distributions"
  homepage "https://github.com/open-telemetry/opentelemetry-collector/tree/main/cmd/builder"
  version "0.147.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_arm64"
      sha256 "37980a292b60f1dfa82f9890f2c6076dcb2883a530104b5131ac2ac109a8076c"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_darwin_amd64"
      sha256 "60c065c251425f9d9f10fc6efc219dfa0e7a040f99a5e54cc5aa3b4e6bddec41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_arm64"
      sha256 "80fbf2a737fa16157a7f6f8a8346f463c78a4bc45fd83d17e0ed5f8669dfdeab"
    end

    on_intel do
      url "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/cmd%2Fbuilder%2Fv#{version}/ocb_#{version}_linux_amd64"
      sha256 "83c5ba0be9e59428b8cecb32179ccf2eccef987a4e43a533095d4d1b8ccf7327"
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
