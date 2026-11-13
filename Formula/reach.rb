class Reach < Formula
  desc "Find and message coding agents by a stable address: machine/space/name"
  homepage "https://github.com/SeeThruHead/reach"
  url "https://github.com/SeeThruHead/reach/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a61f07744aef5a20ba0b10fd7f8cde4c807903738c96c75e56a72d207d2c8809"
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
