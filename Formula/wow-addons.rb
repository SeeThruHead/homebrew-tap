class WowAddons < Formula
  desc "Install and update World of Warcraft addons from CurseForge and GitHub releases"
  homepage "https://gitea.sthloc.vip/sth/wow-addons"
  url "https://gitea.sthloc.vip/sth/wow-addons/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "60a288aa065ca05873516a3bbc6b0dfbdae9f37e8c07f95ecf555dbbc73eec6a"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      The manifest lives in ~/.config/wow-addons/addons.toml (or $WOW_ADDONS_CONFIG).
      GITHUB_TOKEN or GH_TOKEN, when set, is used for GitHub release lookups.
      The source is on the homelab's Gitea, so it installs only on the LAN.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wow-addons --version")
  end
end
