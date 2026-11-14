class SthUpdate < Formula
  desc "Keeps the tools from one Homebrew tap current, and restarts their services"
  homepage "https://github.com/SeeThruHead/sth-update"
  url "https://github.com/SeeThruHead/sth-update/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c9e06fa43f758fe78f5d040e4af0017bcc7eb6ba9597f93841ff1332b78c630f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  service do
    run [opt_bin/"sth-update", "run"]
    keep_alive true
    environment_variables PATH: "#{std_service_path_env}:#{Dir.home}/.local/bin"
    log_path var/"log/sth-update.log"
    error_log_path var/"log/sth-update.log"
  end

  def caveats
    <<~EOS
      Start it, and it updates the tools from seethruhead/tap every hour:
        brew services start seethruhead/tap/sth-update

      sth-update check    what is installed from the tap and what would restart
      sth-update status   the last run
      sth-update now      update now

      Config is optional: ~/.config/sth-update/config.toml (see the README).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-update --version")
    assert_match "has not run yet", shell_output("STH_UPDATE_STATE=#{testpath}/state #{bin}/sth-update status")
  end
end
