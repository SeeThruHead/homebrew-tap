cask "forkyard-bar" do
  version "0.1.0"
  sha256 "b1643956adc15db5fed56bd40b5af0cabf93df10c51c7a1d44c262aa2b6edee4"

  url "https://github.com/SeeThruHead/forkyard-menubar/releases/download/v#{version}/ForkyardBar-#{version}.zip"
  name "Forkyard"
  desc "Menu bar app for the forkyard daemon"
  homepage "https://github.com/SeeThruHead/forkyard-menubar"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "ForkyardBar.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/ForkyardBar.app"]
  end

  uninstall quit: "dev.seethruhead.forkyard-bar"

  zap trash: "~/Library/Preferences/dev.seethruhead.forkyard-bar.plist"
end
