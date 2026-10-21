class Prwatch < Formula
  desc "Hand pull request reviews, comments and CI to the agent working on them"
  homepage "https://github.com/SeeThruHead/prwatch"
  url "https://github.com/SeeThruHead/prwatch/releases/download/v0.2.0/prwatch-0.2.0-macos-arm64.zip"
  sha256 "8256651a8fd25471c1f86e4300225d83c3da1011ab2a96ace2dda3b37e238190"
  license "MIT"

  depends_on arch: :arm64
  depends_on "gh"
  depends_on :macos

  def install
    (prefix/"prwatch.app").install Dir["*"]
    bin.install_symlink prefix/"prwatch.app/Contents/Helpers/prwatch"
  end

  def post_install
    quiet_system "pkill", "-f", "prwatch.app/Contents/MacOS/PrwatchBar"
    rm_r "/Applications/prwatch.app", force: true
    system "ditto", "#{opt_prefix}/prwatch.app", "/Applications/prwatch.app"
  end

  def caveats
    <<~EOS
      To launch:
        open /Applications/prwatch.app

      Enable "Open at login" from the menu bar icon. The app runs the watcher;
      the prwatch command is already on your PATH via Homebrew.

      prwatch reads your pull requests through gh, so log it in first:
        gh auth status

      For cmux, set its socket access to password in cmux's settings.
    EOS
  end

  test do
    assert_predicate prefix/"prwatch.app/Contents/MacOS/PrwatchBar", :executable?
    assert_match "prwatch v#{version}", shell_output("#{bin}/prwatch --version")
  end
end
