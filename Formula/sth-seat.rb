class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.2/sth-seat-darwin-arm64"
      sha256 "552d769f593f9802644bafe83e21f8ecbe0ce0fad76230271ce5d6b8887f087e"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.2/sth-seat-darwin-x64"
      sha256 "9d905bc234e61a0a2161d0e384b4ed7fe640e54f62b213cefef5141455e7448a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.2/sth-seat-linux-arm64"
      sha256 "7ea25827a689df62033e7dc0dd747fd58cf50f1a51db17a2127e8d60c7a3e087"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.2/sth-seat-linux-x64"
      sha256 "7a3066666accba02adff8f8fea447a521e1c2e90976cc623386b355cdb75ad58"
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
