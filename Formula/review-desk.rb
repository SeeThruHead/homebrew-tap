class ReviewDesk < Formula
  desc "Agents do the first review rounds; you get a queue of what needs a person"
  homepage "https://github.com/SeeThruHead/review-desk"
  url "https://github.com/SeeThruHead/review-desk/releases/download/v0.6.1/review-desk-0.6.1-macos-arm64.zip"
  sha256 "8251bf9c368c5fac8823789d8228028420b59b9bc433de04e1ade2b81e8932e4"
  license "MIT"

  depends_on arch: :arm64
  depends_on "gh"
  depends_on :macos

  def install
    bin.install "review-desk", "review-desk-tray"
    pkgshare.install "config.example.json"
  end

  service do
    run opt_bin/"review-desk-tray"
    environment_variables(
      REVIEW_DESK_SERVER: opt_bin/"review-desk",
      PATH:               "#{HOMEBREW_PREFIX}/bin:#{Dir.home}/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
    )
    keep_alive true
    log_path var/"log/review-desk.log"
    error_log_path var/"log/review-desk.log"
  end

  def caveats
    <<~EOS
      Configure it first (repositories, your logins, Gitea if you use it):
        mkdir -p ~/.review-desk
        cp #{opt_pkgshare}/config.example.json ~/.review-desk/config.json

      Then start the menu bar tray, which runs the server:
        brew services start review-desk

      The page is at http://127.0.0.1:4790. GitHub is read through gh, so log it in:
        gh auth status

      Agents are reached in the Herdr TUI, the Herdr app, tmux, cmux, Orca, Rex
      or Claude Code, whichever are on the PATH above; Herdr is optional.
      `review-desk agents` lists what the desk can reach. Other hosts are
      plugins: an executable in ~/.review-desk/plugins (see docs/host-plugins.md).
    EOS
  end

  test do
    assert_match "review-desk", shell_output("#{bin}/review-desk --help")
    assert_predicate bin/"review-desk-tray", :executable?
  end
end
