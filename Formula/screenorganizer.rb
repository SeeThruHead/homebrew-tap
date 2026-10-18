class Screenorganizer < Formula
  desc "Menu bar app that auto-compresses screenshots and screen recordings"
  homepage "https://github.com/SeeThruHead/screen-organizer"
  url "https://github.com/SeeThruHead/screen-organizer/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "079ae8c26274d4cbe2e7ac5bd10b908061b16cc245cef0cf2f49685c68041356"
  license "MIT"

  depends_on :macos
  depends_on "ffmpeg"
  depends_on "imagemagick"

  def install
    quiet_system "pkill", "-f", "ScreenOrganizer"
    mkdir_p "build"
    system "swiftc", "-o", "build/ScreenOrganizer",
           "ScreenOrganizer/main.swift",
           "ScreenOrganizer/AppDelegate.swift",
           "ScreenOrganizer/StatusBarController.swift",
           "ScreenOrganizer/FileWatcher.swift",
           "ScreenOrganizer/FileProcessor.swift",
           "ScreenOrganizer/DateOrganizer.swift",
           "ScreenOrganizer/Config.swift",
           "ScreenOrganizer/SupportedFormats.swift",
           "ScreenOrganizer/Clipboard.swift",
           "ScreenOrganizer/ScreenshotThumbnail.swift",
           "-framework", "Cocoa",
           "-framework", "CoreServices",
           "-O"

    app_dir = prefix/"Screen Organizer.app/Contents"
    (app_dir/"MacOS").mkpath
    cp "build/ScreenOrganizer", app_dir/"MacOS/ScreenOrganizer"
    cp "ScreenOrganizer/Info.plist", app_dir/"Info.plist"

    inreplace app_dir/"Info.plist" do |s|
      s.gsub! "$(PRODUCT_BUNDLE_IDENTIFIER)", "io.github.seethruhead.screenorganizer"
      s.gsub! "$(EXECUTABLE_NAME)", "ScreenOrganizer"
      s.gsub! "$(PRODUCT_NAME)", "Screen Organizer"
      s.gsub! "$(PRODUCT_BUNDLE_PACKAGE_TYPE)", "APPL"
      s.gsub! "$(MARKETING_VERSION)", version.to_s
      s.gsub! "$(CURRENT_PROJECT_VERSION)", "1"
      s.gsub! "$(MACOSX_DEPLOYMENT_TARGET)", "11.0"
      s.gsub! "$(DEVELOPMENT_LANGUAGE)", "en"
    end

    system "codesign", "-s", "-", "--force", prefix/"Screen Organizer.app"
  end

  def caveats
    <<~EOS
      Launch (the path is stable across upgrades):
        open "#{opt_prefix}/Screen Organizer.app"
      Then enable "Open at Login" from the menu bar icon.

      Homebrew's sandbox cannot write to /Applications, so the app is not
      copied there. If you want it in Spotlight:
        ln -s "#{opt_prefix}/Screen Organizer.app" "/Applications/Screen Organizer.app"

      Configuration file: ~/.config/screenorganizer
    EOS
  end

  test do
    assert_predicate prefix/"Screen Organizer.app/Contents/MacOS/ScreenOrganizer", :executable?
  end
end
