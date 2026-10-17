class Forkyard < Formula
  desc "Run many worktrees of the same stack side by side, each at its own URLs"
  homepage "https://github.com/SeeThruHead/forkyard"
  url "https://registry.npmjs.org/forkyard/-/forkyard-0.1.0.tgz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    (bin/"forkyard").write <<~SH
      #!/bin/sh
      exec "#{Formula["node"].opt_bin}/node" --no-warnings "#{opt_libexec}/lib/node_modules/forkyard/dist/bin/forkyard.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Start the daemon as a login service:
        forkyard service install

      Each repo also installs forkyard and effect as dev dependencies, and
      forkyard runs the repo's own copy when you are inside it.
    EOS
  end

  test do
    assert_match "forkyard v#{version}", shell_output("#{bin}/forkyard --version")
  end
end
