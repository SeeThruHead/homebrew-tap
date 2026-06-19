class Graf < Formula
  desc "Agent-first command-line interface for Grafana"
  homepage "https://github.com/SeeThruHead/graf"
  url "https://github.com/SeeThruHead/graf/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9773f415d7bb7d29f1797fbd1d55a32a565f07c3ac1a6336073775db16b08ae3"
  license "MIT"

  depends_on "oven-sh/bun/bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "build", "--compile", "src/main.ts", "--outfile", "graf"
    bin.install "graf"
  end

  def caveats
    <<~EOS
      graf needs a Grafana URL and a credential, from the environment or
      ~/.config/graf/config.json:

        export GRAFANA_URL="https://grafana.example.com"
        export GRAFANA_TOKEN="glsa_..."        # a service-account token
        # or GRAFANA_USER + GRAFANA_PASSWORD for basic auth

      Create a token in Grafana: Administration -> Service accounts.
    EOS
  end

  test do
    assert_match "graf", shell_output("#{bin}/graf --help")
  end
end
