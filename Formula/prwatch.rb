class Prwatch < Formula
  desc "Hand pull request reviews, comments and CI to the agent working on them"
  homepage "https://github.com/SeeThruHead/prwatch"
  url "https://github.com/SeeThruHead/prwatch/releases/download/v0.2.5/prwatch-0.2.5-macos-arm64.zip"
  sha256 "7c1dc36f42d1fcda158036aefcbf6a3286f8416e8d1713069298b0c648d31abb"
  license "MIT"

  depends_on arch: :arm64
  depends_on "gh"
  depends_on :macos

  def install
    (prefix/"prwatch.app").install Dir["*"]
    bin.install_symlink prefix/"prwatch.app/Contents/Helpers/prwatch"
  end

  def caveats
    <<~EOS
      Launch (the path is stable across upgrades):
        open "#{opt_prefix}/prwatch.app"

      Then enable "Open at login" from the menu bar icon. The app runs the
      watcher; the prwatch command is already on your PATH via Homebrew.

      prwatch reads your pull requests through gh, so log it in first:
        gh auth status

      Homebrew's sandbox cannot write to /Applications, so the app is not
      copied there. If you want it in Spotlight:
        ln -s "#{opt_prefix}/prwatch.app" /Applications/prwatch.app

      For cmux, set its socket access to password in cmux's settings.
    EOS
  end

  test do
    assert_predicate prefix/"prwatch.app/Contents/MacOS/PrwatchBar", :executable?
    assert_match "prwatch v#{version}", shell_output("#{bin}/prwatch --version")
  end
end
