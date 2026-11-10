class SthMcp < Formula
  desc "Stateless CLI in front of the MCP router: list servers and tools, call any tool"
  homepage "https://gitea.sthloc.vip/sth/sth-mcp"
  url "https://gitea.sthloc.vip/sth/sth-mcp/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "7f8b3fb2c1caf8880b925c89da82c5cad87cb895720ba09d0ae0bbe58b2d6900"
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
      sth-mcp reads the router password with `sth-bao get shared/mcp-router/password value`
      on each call, so sth-bao must work on this machine. STH_MCP_URL overrides the router
      (default https://mcp.sthloc.vip). Images and audio are saved to ~/tmp/sth-mcp.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-mcp --version")
  end
end
