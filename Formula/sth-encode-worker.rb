class SthEncodeWorker < Formula
  desc "Worker for sth-encode: encodes and checks homelab media, with a tray switch"
  homepage "https://gitea.sthloc.vip/sth/sth-encode"
  url "https://gitea.sthloc.vip/api/packages/sth/generic/sth-encode-worker/0.2.0/sth-encode-worker"
  version "0.2.0"
  sha256 "fa4e25325752e87630dbfd4c31ad7d9ca992d225662813e1010bb4ecfc738c69"
  license "MIT"

  depends_on :linux

  resource "tray" do
    url "https://gitea.sthloc.vip/api/packages/sth/generic/sth-encode-worker/0.2.0/sth-encode-worker-tray"
    sha256 "4d4c0347238f0a6f90e64f5eeedbb3ba2b045b1ffe0fe037f7319134ee809dd1"
  end

  def install
    bin.install "sth-encode-worker"
    resource("tray").stage { bin.install "sth-encode-worker-tray" }
  end

  def caveats
    <<~EOS
      The binaries download from the homelab's Gitea, so this installs only on the LAN.
      Run the worker and the tray as systemd user units with
        ExecStart=#{opt_bin}/sth-encode-worker
        ExecStart=#{opt_bin}/sth-encode-worker-tray tray
      (docs/worker.md in sth-encode has both units). The tray needs GTK 3 and
      libayatana-appindicator from the system. After `brew upgrade sth-encode-worker`,
      restart sth-encode-worker only when it holds no job.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-encode-worker --version")
    assert_match version.to_s, shell_output("#{bin}/sth-encode-worker-tray --version")
  end
end
