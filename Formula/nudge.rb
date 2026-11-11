class Nudge < Formula
  desc "Sends messages to coding agents in Herdr, on a schedule or on demand"
  homepage "https://github.com/SeeThruHead/nudge"
  url "https://github.com/SeeThruHead/nudge/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "62f1067cdfa2fed2a860b737a6d5e8ab58eb45576823438e097739e07b8adfb3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  service do
    run [opt_bin/"nudge", "run"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/nudge.log"
    error_log_path var/"log/nudge.log"
  end

  def caveats
    <<~EOS
      Write jobs in ~/.config/nudge/config.toml (see the README), then:
        brew services start seethruhead/tap/nudge

      nudge check   shows the host it found, where each job goes and when it runs next.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nudge --version")
    (testpath/"config.toml").write <<~TOML
      [[job]]
      name = "standup"
      cron = "0 9 * * 1-5"
      target = { cwd = "#{testpath}" }
      message = "Summarise yesterday."
    TOML
    ENV["NUDGE_CONFIG"] = testpath/"config.toml"
    assert_match "standup: cron 0 9 * * 1-5", shell_output("#{bin}/nudge check")
  end
end
