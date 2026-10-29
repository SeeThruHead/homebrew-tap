class ScarlettMono < Formula
  desc "Menu bar helper that sends one Scarlett input to both BlackHole channels"
  homepage "https://github.com/SeeThruHead/scarlett-mono"
  url "https://github.com/SeeThruHead/scarlett-mono/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "09b78c964378b01d3ee85e92d2208766498a94cd74f94bc8175c37bb28363437"

  depends_on :macos

  def install
    app_dir = prefix/"Scarlett Mono.app/Contents"
    (app_dir/"MacOS").mkpath
    system "xcrun", "clang++", "-std=c++20", "-fobjc-arc", "-O2", "-mmacosx-version-min=14.0",
           "-framework", "AppKit", "-framework", "AVFoundation", "-framework", "CoreAudio",
           "Sources/main.mm", "-o", app_dir/"MacOS/ScarlettMono"
    cp "Info.plist", app_dir/"Info.plist"
    inreplace app_dir/"Info.plist", "<key>CFBundleShortVersionString</key><string>1.0.0</string>",
              "<key>CFBundleShortVersionString</key><string>#{version}</string>"
    system "codesign", "-s", "-", "--force", prefix/"Scarlett Mono.app"
  end

  service do
    run [opt_prefix/"Scarlett Mono.app/Contents/MacOS/ScarlettMono"]
    keep_alive successful_exit: false
    process_type :interactive
    log_path var/"log/scarlett-mono.log"
    error_log_path var/"log/scarlett-mono.log"
  end

  def caveats
    <<~EOS
      Needs the BlackHole 2ch driver:
        brew install --cask blackhole-2ch

      Start it now and at login:
        brew services start scarlett-mono

      macOS asks for microphone access on first launch and after each upgrade.
      In Screenshot (Cmd-Shift-5) → Options → Microphone, choose BlackHole 2ch.
    EOS
  end

  test do
    assert_predicate prefix/"Scarlett Mono.app/Contents/MacOS/ScarlettMono", :executable?
  end
end
