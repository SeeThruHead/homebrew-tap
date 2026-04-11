class Portkill < Formula
  desc "TUI to list listening ports and kill processes with vim bindings"
  homepage "https://github.com/SeeThruHead/portkill"
  url "https://github.com/SeeThruHead/portkill/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2f8eb1f5cd64f4662646536765ab5c148fc905563116fd3fe99ab1e03f9de036"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      portkill uses `lsof` to enumerate listening ports and `kill` to terminate
      processes — both ship with macOS, no extra dependencies.

      Keys:
        j/k       move       x    SIGTERM selected
        g/G       top/bot    X    SIGKILL selected
        s/S      mark/unmark system service
        r         refresh    q    quit

      Promoted system services are persisted to ~/.config/portkill/system.txt
    EOS
  end

  test do
    assert_predicate bin/"portkill", :exist?
  end
end
