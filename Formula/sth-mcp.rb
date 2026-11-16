class SthMcp < Formula
  desc "CLI in front of the MCP router: list servers and tools, call any tool"
  homepage "https://gitea.sthloc.vip/sth/sth-mcp"
  url "https://gitea.sthloc.vip/sth/sth-mcp/archive/v0.4.0.tar.gz"
  version "0.4.0"
  sha256 "7e2e8e86e6d2f62ca30f55216b378c4dfacaacf13d4da54ba2b8fc314f6cc2d7"
  license "MIT"

  on_macos do
    depends_on "oven-sh/bun/bun" => :build
  end

  on_linux do
    depends_on "bun" => :build
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    cd "apps/cli" do
      system "bun", "build", "--compile", "src/main.ts", "--outfile", "sth-mcp"
      bin.install "sth-mcp"
    end
  end

  def caveats
    <<~EOS
      sth-mcp reads the router token on the first request, from the file STH_MCP_TOKEN_FILE
      names, else ~/.config/sth-mcp/token when it exists (mode 600), else with
      `sth-bao get shared/mcp-router/password value`. STH_MCP_URL overrides the router
      (default https://mcp.sthloc.vip). Images and audio are saved to ~/tmp/sth-mcp.
      Safe-to-repeat calls made while the router is away wait in ~/.local/state/sth-mcp/outbox
      and are sent by the next command; `sth-mcp outbox` lists them.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-mcp --version")
  end
end
