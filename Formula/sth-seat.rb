class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.8.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.5/sth-seat-darwin-arm64.app.tar.gz"
      sha256 "707f8bb3ad495fae34700ce620e2c36d4192dff21a0b27ab455786db75da3391"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.5/sth-seat-darwin-x64.app.tar.gz"
      sha256 "477f43079034f7e7f448d2bdc787ff115298b1f30e826eaacf6fbfc4a5d75814"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.5/sth-seat-linux-arm64"
      sha256 "fa0d08f5583329151b35268cff9c5b0ac6ab7f80133f9de528faf6586fc7004f"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.5/sth-seat-linux-x64"
      sha256 "a5fb63e12f6b9ea0daa21c8bdf41bcb52074eb53136b1f98514dad063acf9ddb"
    end
  end

  def install
    if OS.mac?
      app = prefix/"sth-seat.app"
      if File.directory?("sth-seat.app")
        prefix.install "sth-seat.app"
      else
        app.install "Contents"
      end
      bin.install_symlink app/"Contents/MacOS/sth-seat"
    else
      bin.install Dir["sth-seat-*"].first => "sth-seat"
    end
  end

  def caveats
    <<~EOS
      Set the machine up, then start the daemon as a user service:
        sth-seat key --name <name> --hub wss://<your hub>/daemon
        sth-seat install

      `sth-seat install` points a launchd agent (macOS) or systemd user unit (Linux) at
      #{HOMEBREW_PREFIX}/bin/sth-seat. After `brew upgrade sth-seat`, run `sth-seat install`
      again to restart it on the new version.

      On macOS sth-seat is a signed app (com.seethruhead.sth-seat), so macOS keeps your answers
      to its privacy prompts across upgrades.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-seat --version")
  end
end
