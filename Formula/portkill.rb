class Portkill < Formula
  desc "TUI to list listening ports and kill processes with vim bindings"
  homepage "https://github.com/SeeThruHead/portkill"
  url "https://github.com/SeeThruHead/portkill/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2be67a8dd141b003b8ac61f4546904bd5f77b6cf224fddd5881abf25cac42cab"
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
