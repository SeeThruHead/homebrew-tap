class Aihist < Formula
  desc "Unified AI conversation history CLI for Claude Code, Codex, and OpenCode"
  homepage "https://github.com/SeeThruHead/aihist"
  url "https://github.com/SeeThruHead/aihist/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "f4c7822c044fed6fd539ab9dc2cc0062a25a3e33cb5b301fbe6d5c82a2194cd1"
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
