class Handoff < Formula
  desc "Menu bar panel and CLI for the files your agents produce"
  homepage "https://github.com/SeeThruHead/handoff"
  url "https://github.com/SeeThruHead/handoff/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3955d5cecad6617882fa4ebebe5b485124f4694980c433101493bee740cef4d1"
  license "MIT"

  depends_on :macos
  depends_on "grip"

  def install
    system "./build.sh", version.to_s

    app = prefix/"Handoff.app"
    cp_r "build/Handoff.app", app
    bin.install_symlink app/"Contents/Helpers/handoff"
  end

  def caveats
    <<~EOS
      Launch (the path is stable across upgrades):
        open "#{opt_prefix}/Handoff.app"

      Then in the panel's settings (gear): Open at login, Install skill.
      The handoff CLI is already on your PATH via Homebrew.

      Homebrew's sandbox cannot write to /Applications, so the app is not
      copied there. If you want it in Spotlight:
        ln -s "#{opt_prefix}/Handoff.app" /Applications/Handoff.app
    EOS
  end

  test do
    assert_predicate prefix/"Handoff.app/Contents/MacOS/Handoff", :executable?
    assert_match "usage: handoff", shell_output("#{bin}/handoff --help")
  end
end
