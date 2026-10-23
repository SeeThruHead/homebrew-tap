cask "forkyard-bar" do
  version "0.1.1"
  sha256 "76a8791448ae4485e525c083ec746259c5727010e7231b50960443678405f7b0"

  url "https://github.com/SeeThruHead/forkyard-menubar/releases/download/v#{version}/ForkyardBar-#{version}.zip"
  name "Forkyard"
  desc "Menu bar app for the forkyard daemon"
  homepage "https://github.com/SeeThruHead/forkyard-menubar"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "ForkyardBar.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/ForkyardBar.app"],
        writable_paths: ["ForkyardBar.app"],
        writable_base:  :appdir
  end

  uninstall quit: "dev.seethruhead.forkyard-bar"

  zap trash: "~/Library/Preferences/dev.seethruhead.forkyard-bar.plist"
end
