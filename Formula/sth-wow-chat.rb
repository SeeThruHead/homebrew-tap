class SthWowChat < Formula
  desc "Voice chat for World of Warcraft on Linux, through your own Whisper server"
  homepage "https://gitea.sthloc.vip/sth/sth-wow-chat"
  url "https://gitea.sthloc.vip/sth/sth-wow-chat/archive/v0.3.0.tar.gz"
  version "0.3.0"
  sha256 "379db9cbae5c90734ef7bf832573658f170e1014367524dbbaf4bcca4fbad2d2"
  license "MIT"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    inreplace "systemd/sth-wow-chat.service", "%h/.local/bin/sth-wow-chat", opt_bin/"sth-wow-chat"
    (share/"systemd/user").install "systemd/sth-wow-chat.service"
  end

  def caveats
    <<~EOS
      Run the service as a systemd user unit, so it starts with your graphical session:
        systemctl --user link #{opt_share}/systemd/user/sth-wow-chat.service
        systemctl --user enable --now sth-wow-chat

      It needs read access to /dev/input/event* (to hear the keys), write access to
      /dev/uinput (to type into the game), and pw-record and pw-play.
      Settings live in ~/.config/sth-wow-chat/settings.json. In gamescope's game mode,
      set "keys_from": "x" so it hears the keys Steam Input sends.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-wow-chat --version")
  end
end
