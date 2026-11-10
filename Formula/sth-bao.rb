class SthBao < Formula
  desc "Secrets, database logins and SSH certificates from the homelab's OpenBao"
  homepage "https://gitea.sthloc.vip/sth/sth-bao"
  url "https://gitea.sthloc.vip/sth/sth-bao/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "5aa672b12e90de78bba3db3f62cc4605a37f18a6231f353ef454d919627c170d"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      sth-bao signs in with this machine's AppRole, read from ~/.config/openbao/role-id and
      secret-id (mode 600). The source is on the homelab's Gitea, so it installs only on the LAN.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-bao --version")
  end
end
