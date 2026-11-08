class SthDictate < Formula
  desc "Dictation against your own Whisper server, for Linux"
  homepage "https://github.com/SeeThruHead/sth-dictate"
  url "https://github.com/SeeThruHead/sth-dictate/archive/refs/tags/linux-v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "5d5f8593cc10dffb606c814832988de1b8b904f8e8fcc3b0b1f730b34f5e8204"
  license "MIT"

  depends_on "rust" => :build
  depends_on :linux

  def install
    cd "linux" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
      inreplace "systemd/sth-dictate.service", "%h/.local/bin/sth-dictate", opt_bin/"sth-dictate"
      (share/"systemd/user").install "systemd/sth-dictate.service"
    end
  end

  def caveats
    <<~EOS
      Run the service as a systemd user unit, so it starts with your graphical session:
        systemctl --user link #{opt_share}/systemd/user/sth-dictate.service
        systemctl --user enable --now sth-dictate

      It needs your user in the input group (to hear the hotkey), write access to
      /dev/uinput (to press the paste keys), and pw-record, pw-play, wl-copy and hyprctl.
      Settings live in ~/.config/sth-dictate/settings.json.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-dictate --version")
  end
end
