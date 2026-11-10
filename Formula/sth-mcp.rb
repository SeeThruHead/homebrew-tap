class SthMcp < Formula
  desc "Stateless CLI in front of the MCP router: list servers and tools, call any tool"
  homepage "https://gitea.sthloc.vip/sth/sth-mcp"
  url "https://gitea.sthloc.vip/sth/sth-mcp/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "eb67b28b5ebb7ce9071794b61bf2d58d75d6dd8c8e6c38650c0422343f011778"
  license "MIT"

  depends_on "oven-sh/bun/bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "build", "--compile", "src/main.ts", "--outfile", "sth-mcp"
    bin.install "sth-mcp"
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
