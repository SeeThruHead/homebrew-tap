class SthSeat < Formula
  desc "Makes all of your machines act like the one you are sitting at, for you and your coding agents"
  homepage "https://github.com/SeeThruHead/sth-seat"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.7.0/sth-seat-darwin-arm64"
      sha256 "24f69470932128584b11408e2275645c477cf6e5f3785eef81605826513b67b5"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.7.0/sth-seat-darwin-x64"
      sha256 "afaa633028cee749f0fe905faf730b488b6b1cacbede18c9553abd7f11de4120"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.7.0/sth-seat-linux-arm64"
      sha256 "b6c5113cd0e88137637e6029fbc2c01d6f762daa87097121b033574dc84f9879"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-seat/releases/download/v0.7.0/sth-seat-linux-x64"
      sha256 "0c41079d62f74765065f6bd420fed47505a7409c2fb5af6dbbeefa8218bc2760"
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
