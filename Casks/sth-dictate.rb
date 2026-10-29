cask "sth-dictate" do
  version "0.7.0"
  sha256 "3fbd36e326bd56ba6da906a9594a021697a589df7867daa23faf9c6bb17ad4f0"

  url "https://github.com/SeeThruHead/sth-dictate/releases/download/v#{version}/SthDictate-#{version}.zip"
  name "SthDictate"
  desc "Menu bar dictation against your own Whisper server"
  homepage "https://github.com/SeeThruHead/sth-dictate"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "SthDictate.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SthDictate.app"],
        writable_paths: ["SthDictate.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.sth.dictate"

  zap trash: [
    "~/Library/Caches/com.sth.dictate",
    "~/Library/Preferences/com.sth.dictate.plist",
  ]
end
