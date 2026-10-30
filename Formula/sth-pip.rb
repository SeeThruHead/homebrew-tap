class SthPip < Formula
  desc "Always-on-top webcam picture-in-picture overlay"
  homepage "https://github.com/SeeThruHead/sth-pip"
  url "https://github.com/SeeThruHead/sth-pip/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "06b5058529b89a34ee8b51179fd37585252b653055167b6d4b97511389951c8d"
  license "MIT"

  depends_on :macos

  def install
    quiet_system "pkill", "-f", "SthPiP"
    mkdir_p "build"
    system "swiftc", "-o", "build/SthPiP",
           "SthPiP/main.swift",
           "SthPiP/StateBroadcast.swift",
           "-framework", "Cocoa",
           "-framework", "AVFoundation",
           "-O"

    app_dir = prefix/"SthPiP.app/Contents"
    (app_dir/"MacOS").mkpath
    cp "build/SthPiP", app_dir/"MacOS/SthPiP"
    cp "SthPiP/Info.plist", app_dir/"Info.plist"

    inreplace app_dir/"Info.plist" do |s|
      s.gsub! "<string>1.0</string>", "<string>#{version}</string>"
    end

    system "codesign", "-s", "-", "--force", prefix/"SthPiP.app"
  end

  def caveats
    <<~EOS
      To launch:
        open "#{opt_prefix}/SthPiP.app"

      Left-click the menu bar icon to toggle camera.
      Right-click for options (Open at Login, Quit).

      For Amethyst, add "com.sth.pip" to your floating list.

      Homebrew's sandbox cannot write to /Applications, so the app is not
      linked there. If you want it in Spotlight:
        ln -s "#{opt_prefix}/SthPiP.app" /Applications/SthPiP.app
    EOS
  end

  test do
    assert_predicate prefix/"SthPiP.app/Contents/MacOS/SthPiP", :executable?
  end
end
