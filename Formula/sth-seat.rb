class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.8.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.1/sth-seat-darwin-arm64.app.tar.gz"
      sha256 "d548734c3f053b90e70cd62201b17f6492bb4cb755ab09d16fd8ee875ce75456"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.1/sth-seat-darwin-x64.app.tar.gz"
      sha256 "fc384d4e486caf56c8a8616ded08891aafb3916836ffae846d16211a4a2ad217"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.1/sth-seat-linux-arm64"
      sha256 "8345c4b3c951f8f63ac0ee61238cdee05d314f790481d764dbb9709cf831dbb6"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.8.1/sth-seat-linux-x64"
      sha256 "143a8d7092fc8db4ba3d15acd546a1c68702a2d79a091529cd514732a86ba612"
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
