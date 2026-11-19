class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.8.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.4/sth-seat-darwin-arm64.app.tar.gz"
      sha256 "05a89bf0ce46ad6e331d8f933a8f14ac4f47ffec4f2eda438f8ef4cb40fd0780"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.4/sth-seat-darwin-x64.app.tar.gz"
      sha256 "af04d1337a6f8d877d32141ac3e33914beb86435c738a36b7b3183d8644a91bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.4/sth-seat-linux-arm64"
      sha256 "581fa120cb078e812d178ad705f8e6a3499de5014574c7dbbfdb50e88ca4960b"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.4/sth-seat-linux-x64"
      sha256 "3beee67de356a481c2666b6336c1e5e36d390eba37aa03949b6e46bf759fae26"
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
