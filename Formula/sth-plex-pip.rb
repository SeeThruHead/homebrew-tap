class SthPlexPip < Formula
  desc "Floating, click-through Plex picture-in-picture player"
  homepage "https://github.com/SeeThruHead/sth-plex-pip"
  version "0.1.0"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    depends_on "mpv"

    on_arm do
      url "https://github.com/SeeThruHead/sth-plex-pip/releases/download/v0.1.0/sth-plex-pip-darwin-arm64"
      sha256 "4881eb11454936a43c553c9a7f57a38725599e05a786d409165207a0809b2482"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/SeeThruHead/sth-plex-pip/releases/download/v0.1.0/sth-plex-pip-linux-x64"
      sha256 "e875c1f33840ddfaa5fde035c2bf8abccdd6443aae997c29201f61bd2730aa10"
    end
  end

  def install
    bin.install Dir["sth-plex-pip-*"].first => "sth-plex-pip"
    install_app if OS.mac?
  end

  def install_app
    contents = prefix/"SthPlexPip.app/Contents"
    (contents/"MacOS").mkpath
    cp bin/"sth-plex-pip", contents/"MacOS/sth-plex-pip"
    (contents/"Info.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleIdentifier</key><string>com.sth.plexpip</string>
        <key>CFBundleName</key><string>SthPlexPip</string>
        <key>CFBundleExecutable</key><string>sth-plex-pip</string>
        <key>CFBundlePackageType</key><string>APPL</string>
        <key>CFBundleShortVersionString</key><string>#{version}</string>
        <key>LSUIElement</key><true/>
      </dict>
      </plist>
    EOS
    system "codesign", "-s", "-", "--force", prefix/"SthPlexPip.app"
  end

  def caveats
    on_macos do
      <<~EOS
        Run `sth-plex-pip`, or launch the app (the path is stable across upgrades):
          open "#{opt_prefix}/SthPlexPip.app"

        Homebrew cannot write to /Applications. For Spotlight and launchers:
          ln -sfn "#{opt_prefix}/SthPlexPip.app" /Applications/SthPlexPip.app

        Hotkeys are Ctrl+Option with P (controls), Space, arrows, H, Minus and Equal.
      EOS
    end
    on_linux do
      <<~EOS
        The player uses the system's mpv library (libmpv.so.2, from the mpv or libmpv2
        package) and needs a Wayland compositor with layer-shell.

        Wayland has no global hotkeys for applications: bind keys in your compositor to
        `#{opt_bin}/sth-plex-pip controls`, `pause`, `seek 30` and so on.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-plex-pip --version")
  end
end
