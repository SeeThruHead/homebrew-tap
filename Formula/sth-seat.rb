class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.0/sth-seat-darwin-arm64"
      sha256 "058c21b559ac12c5a046b4ed3346fa2ece4e8c59f3d05733e4ac2e61993f6864"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.0/sth-seat-darwin-x64"
      sha256 "787e93887ac89916538cf3f583fb4b40a21410cb43a5e2b85593798cdb4f1fdb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.0/sth-seat-linux-arm64"
      sha256 "2c316b1cc660c5f20627bcf5852b5902fe4cd31c26e7f0a6025615c0ce186637"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.0/sth-seat-linux-x64"
      sha256 "3a0e38ddde437b487c92065ac9b50720718006e45a5060044785e75491da35ec"
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
