class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.0/sth-seat-darwin-arm64"
      sha256 "4b72fc8d1b8cdcfc3beef710e9a2396cf918a2aef9a6fc349a3fd3a3a7250c41"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.0/sth-seat-darwin-x64"
      sha256 "3ed3bc62d2089027156183cb8ac5a6fbb17bcd73d69f42cbe3409c79aad99e6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.0/sth-seat-linux-arm64"
      sha256 "c567adef8aa69b87e41ff424a4a7aa5b20e1ecb2edafce5704884963e772fa5c"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.4.0/sth-seat-linux-x64"
      sha256 "1d21f858ebcba0982b6c29f4ccaf144a61f574ac6440be35e95dc5b957414980"
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

      `sth-seat install` copies the binary to ~/.local/bin/sth-seat and installs a launchd
      agent (macOS) or systemd user unit (Linux). After `brew upgrade sth-seat`, run
      `sth-seat install` again so the service uses the new binary.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-seat --version")
  end
end
