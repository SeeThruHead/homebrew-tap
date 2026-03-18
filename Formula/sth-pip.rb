class SthPip < Formula
  desc "Always-on-top webcam picture-in-picture overlay"
  homepage "https://github.com/SeeThruHead/sth-pip"
  url "https://github.com/SeeThruHead/sth-pip/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "96cebff52175075eb6eead20231465320c55b5813661ea3dda612f8072268e2c"
  license "MIT"

  depends_on :macos

  def install
    quiet_system "pkill", "-f", "SthPiP"
    mkdir_p "build"
    system "swiftc", "-o", "build/SthPiP",
           "SthPiP/main.swift",
           "-framework", "Cocoa",
           "-framework", "AVFoundation",
           "-O"

    app_dir = prefix/"SthPiP.app/Contents"
    (app_dir/"MacOS").mkpath
    cp "build/SthPiP", app_dir/"MacOS/SthPiP"
    cp "SthPiP/Info.plist", app_dir/"Info.plist"

    system "codesign", "-s", "-", "--force", prefix/"SthPiP.app"
  end

  def post_install
    quiet_system "pkill", "-f", "SthPiP"
    system "ln", "-sf", "#{opt_prefix}/SthPiP.app", "/Applications/SthPiP.app"
  end

  def caveats
    <<~EOS
      To launch:
        open "/Applications/SthPiP.app"

      Left-click the menu bar icon to toggle camera.
      Right-click for options (Open at Login, Quit).

      For Amethyst, add "com.sth.pip" to your floating list.
    EOS
  end

  test do
    assert_predicate prefix/"SthPiP.app/Contents/MacOS/SthPiP", :executable?
  end
end
