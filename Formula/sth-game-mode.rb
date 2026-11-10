class SthGameMode < Formula
  desc "Tray switch for a Hyprland game mode that pins Herdr and WoW side by side"
  homepage "https://gitea.sthloc.vip/sth/sth-game-mode"
  url "https://gitea.sthloc.vip/sth/sth-game-mode/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "403deea0b7b69a0befb3a9b900653e618fdcace441696e95af85d330b16783bc"
  license "MIT"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      It drives the Hyprland plugin that provides the sth_game_mode dispatcher, and does
      nothing without it. Start the tray with your session, for example an XDG autostart
      entry running: #{opt_bin}/sth-game-mode tray
      The source is on the homelab's Gitea, so it installs only on the LAN.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-game-mode --version")
  end
end
