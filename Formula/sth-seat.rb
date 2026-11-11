class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.5.0/sth-seat-darwin-arm64"
      sha256 "bc1f63cf64815587aae2571d9c410874bdaa8c5c7000de9614dbd9443c34e4b0"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.5.0/sth-seat-darwin-x64"
      sha256 "186d33455114b14d6d07df350759d545edf4c375ccbfaf7511296b4adf4b6b07"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.5.0/sth-seat-linux-arm64"
      sha256 "b4c866a3cb8cf876843b60a0cbe7c1311236fab09b57acc28c3e810332a7e94d"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.5.0/sth-seat-linux-x64"
      sha256 "6c9ac9b1ccac69904f2772542cb5039c01034e7938147e15cfba87e01dfc1308"
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
