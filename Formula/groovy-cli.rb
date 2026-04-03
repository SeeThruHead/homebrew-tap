class GroovyCli < Formula
  desc "Stream Plex media to MiSTer FPGA CRT via Groovy protocol"
  homepage "https://github.com/SeeThruHead/groovy-cli"
  url "https://github.com/SeeThruHead/groovy-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f7843db520413ea080365516da3e27f08f3175cc94394e30f096a06b254b05e5"
  license "MIT"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      groovy-cli requires FFmpeg with libass for subtitle support.
      The standard Homebrew FFmpeg includes libass by default.

      First-time setup:
        groovy-cli auth          # authenticate with Plex
        groovy-cli config        # show config file location

      Requires MiSTer FPGA with Groovy core loaded.
    EOS
  end

  test do
    assert_match "groovy-cli", shell_output("#{bin}/groovy-cli --help")
  end
end
