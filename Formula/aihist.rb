class Aihist < Formula
  desc "Unified AI conversation history CLI for Claude Code, Codex, and OpenCode"
  homepage "https://github.com/SeeThruHead/aihist"
  url "https://github.com/SeeThruHead/aihist/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "fd12571dfa9fee982859be6406d9aa130c46ea78cc46c9571c4cda22d33cc5d9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  def caveats
    <<~EOS
      Index your sessions before searching:
        aihist index

      Install agent skills into each detected harness (Claude Code, Codex, OpenCode, Pi):
        aihist install-skills

      The database lives at ~/.local/share/aihist/aihist.db by default.
      Override with CLAUDE_DIR, CODEX_DIR, or OPENCODE_DB environment variables.
    EOS
  end

  test do
    assert_match "aihist", shell_output("#{bin}/aihist --help")
    assert_match "index", shell_output("#{bin}/aihist --help")
  end
end
