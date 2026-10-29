cask "forkyard-bar" do
  version "0.1.3"
  sha256 "0ffc4b4074fbf2cf3afdc05e1d5ecc258c40198080f47eb14158c307c5ab716a"

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
