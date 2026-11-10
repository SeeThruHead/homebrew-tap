class SthVitals < Formula
  desc "Push a machine's vitals (CPU, memory, GPU, disks, sensors) to the homelab's Alloy as OTLP"
  homepage "https://gitea.sthloc.vip/sth/sth-vitals"
  url "https://gitea.sthloc.vip/sth/sth-vitals/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "67c296b26cf73b1b21562beb0fb433f25b2ec0046e6b648e86eaeaf94d325ccb"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      The formula has no service: each machine runs sth-vitals under its own name. Run
      #{opt_bin}/sth-vitals from a launchd agent (macOS) or a systemd user unit (Linux) with
      VITALS_HOST=<name>; the README in the source has both. The source is on the homelab's
      Gitea, so it installs only on the LAN.
    EOS
  end

  test do
    assert_match "sth-vitals #{version}", shell_output("#{bin}/sth-vitals --version")
  end
end
