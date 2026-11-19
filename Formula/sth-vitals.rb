class SthVitals < Formula
  desc "Push a machine's vitals (CPU, memory, GPU, disks, sensors) to the homelab's Alloy as OTLP"
  homepage "https://gitea.sthloc.vip/sth/sth-vitals"
  url "https://gitea.sthloc.vip/sth/sth-vitals/archive/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "7c1a415e12bbe7ef512dd126d4e5796e6f6c70d25593868e4be982a65dfed99c"

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
