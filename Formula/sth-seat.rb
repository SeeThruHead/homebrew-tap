class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.6.0/sth-seat-darwin-arm64"
      sha256 "1f5794408d752600ab6a5a15da9ded5c883f575d04403ccbdec5ff309313c2d8"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.6.0/sth-seat-darwin-x64"
      sha256 "8e1a553e89980489928267b9d6995ab4f5f81283dff90c8c99345627ac5dab4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.6.0/sth-seat-linux-arm64"
      sha256 "c378ce8f4e0f985c5ef7fe75aba43cbc133555ac69ab25cbeec85e6a6ebbd979"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.6.0/sth-seat-linux-x64"
      sha256 "0a23ffdf61302606f344e9ec29cf54ec9436e9731dd62953c17f98049730f204"
    end
  end

  def install
    bin.install Dir["sth-seat-*"].first => "sth-seat"
  end

  def caveats
    <<~EOS
      Set the machine up, then start the daemon as a user service:
        sth-seat key --name <name> --hub wss://<your hub>/daemon
        sth-seat install

      `sth-seat install` points a launchd agent (macOS) or systemd user unit (Linux) at
      #{HOMEBREW_PREFIX}/bin/sth-seat. After `brew upgrade sth-seat`, run `sth-seat install`
      again to restart it on the new version.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-seat --version")
  end
end
