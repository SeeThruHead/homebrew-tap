class Canonry < Formula
  desc "Write a decision once, deliver it everywhere, and block only new violations"
  homepage "https://github.com/SeeThruHead/canonry"
  url "https://github.com/SeeThruHead/canonry/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "04d9608afcd202a3b6a020dc9adf204cf8f382f248b228ef0e34d33c83095d23"
  license "MIT"

  on_macos do
    depends_on "oven-sh/bun/bun" => :build
  end

  on_linux do
    depends_on "bun" => :build
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    cd "packages/canonry" do
      system "bun", "build", "--compile", "src/main.ts", "--outfile", "canonry"
      bin.install "canonry"
    end
  end

  def caveats
    <<~EOS
      canonry lists files through git, so run it inside a git repository.
      Try it on the sample in the repository: canonry --repo examples/app check
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/canonry --version")
  end
end
