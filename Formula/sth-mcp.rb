class SthMcp < Formula
  desc "Stateless CLI in front of the MCP router: list servers and tools, call any tool"
  homepage "https://gitea.sthloc.vip/sth/sth-mcp"
  url "https://gitea.sthloc.vip/sth/sth-mcp/archive/v0.3.0.tar.gz"
  version "0.3.0"
  sha256 "f855ac110689e36d9dc90d7d3118f5950c8f5f3c3b8382520682311797ae0af5"
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
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-mcp --version")
  end
end
