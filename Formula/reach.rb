class Reach < Formula
  desc "Find and message coding agents by a stable address: machine/space/name"
  homepage "https://github.com/SeeThruHead/reach"
  url "https://github.com/SeeThruHead/reach/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c8d18d82d79c2e1468460599ce1c4e088a9b1da61d5705229118a16af564001d"
  license "MIT"

  depends_on "oven-sh/bun/bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "build", "--compile", "src/main.ts", "--outfile", "reach"
    bin.install "reach"
  end

  def caveats
    <<~EOS
      reach ls      lists every agent the hosts report (Herdr app, tmux, plugins) with its address.
      Set this machine's name in ~/.config/reach/config.json: { "machine": "<name>" }
      (default: the short host name, lowercased).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reach --version")
    output = shell_output("#{bin}/reach resolve 'Not An Address' 2>&1", 1)
    assert_match "is not an address", output
  end
end
