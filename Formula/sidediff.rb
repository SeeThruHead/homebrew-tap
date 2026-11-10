class Sidediff < Formula
  desc "GitHub-style diff review in the browser, with a live notes column for humans and agents"
  homepage "https://github.com/SeeThruHead/sidediff"
  url "https://registry.npmjs.org/sidediff/-/sidediff-0.8.0.tgz"
  sha256 "42a7410c5fa236238afd60b4fd0b9c90ae20c609a809827a292f6ecd65454272"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "sidediff", shell_output("#{bin}/sidediff --help 2>&1")
  end
end
