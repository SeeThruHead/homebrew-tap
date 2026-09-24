class Handoff < Formula
  desc "Menu bar panel and CLI for the files your agents produce"
  homepage "https://github.com/SeeThruHead/handoff"
  url "https://github.com/SeeThruHead/handoff/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3955d5cecad6617882fa4ebebe5b485124f4694980c433101493bee740cef4d1"
  license "MIT"

  depends_on :macos
  depends_on "grip"

  def install
    quiet_system "pkill", "-f", "Handoff.app/Contents/MacOS/Handoff"
    system "./build.sh", version.to_s

    app = prefix/"Handoff.app"
    cp_r "build/Handoff.app", app
    bin.install_symlink app/"Contents/Helpers/handoff"
  end

  def post_install
    quiet_system "pkill", "-f", "Handoff.app/Contents/MacOS/Handoff"
    system "rm", "-rf", "/Applications/Handoff.app"
    system "ditto", "#{opt_prefix}/Handoff.app", "/Applications/Handoff.app"
  end

  def caveats
    <<~EOS
      To launch:
        open /Applications/Handoff.app

      In the panel's settings (gear): Install skill, Open at login.
      The handoff CLI is already on your PATH via Homebrew.
    EOS
  end

  test do
    assert_predicate prefix/"Handoff.app/Contents/MacOS/Handoff", :executable?
    assert_match "usage: handoff", shell_output("#{bin}/handoff --help")
  end
end
