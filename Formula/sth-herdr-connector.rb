class SthHerdrConnector < Formula
  desc "Connects this machine's agents (Herdr TUI, Herdr app, Claude Code, Codex, Pi) to a hub, outbound only"
  homepage "https://github.com/SeeThruHead/sth-herdr-connector"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.3.0/sth-herdr-connector-darwin-arm64"
      sha256 "d84c5182a1dac672e2d25ed8fa98f140678bed691b0cefb3da43fc898b1227a5"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.3.0/sth-herdr-connector-darwin-x64"
      sha256 "58b122169d094df2e6ed0d2f84ada61ebbc3e13282a2a85800420c7899f38cf2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.3.0/sth-herdr-connector-linux-arm64"
      sha256 "c6a7830c9dead9f8e895f60212ae39d8fdf230ce94cffb32aa656cdea2bc4f27"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.3.0/sth-herdr-connector-linux-x64"
      sha256 "9ef8f5c23f374066919d3243d58cf6342cf915f96804d7bb94d01e3097ee82fe"
    end
  end

  def install
    binary = Dir["sth-herdr-connector-*"].first
    if OS.mac?
      system "codesign", "--remove-signature", binary
      system "codesign", "--force", "--sign", "-", binary
    end
    bin.install binary => "sth-herdr-connector"
  end

  service do
    run [opt_bin/"sth-herdr-connector"]
    keep_alive true
    environment_variables PATH: "#{std_service_path_env}:#{Dir.home}/.local/bin"
    log_path var/"log/sth-herdr-connector.log"
    error_log_path var/"log/sth-herdr-connector.log"
  end

  def caveats
    <<~EOS
      Before starting it, write the hub's connector address and this machine's token:
        ~/.config/sth-herdr/hub     wss://<hub>/connector
        ~/.config/sth-herdr/token   a token made on this machine (mode 600); the hub gets only its hash
      The README at https://github.com/SeeThruHead/sth-herdr-connector has the commands.
      Check it reaches the hub, then start it:
        HERDR_CONNECTOR_PROBE=1 sth-herdr-connector
        brew services start sth-herdr-connector
      It finds herdr and hc on the service PATH. `brew upgrade sth-herdr-connector` and
      `brew services restart sth-herdr-connector` bring a new release.
    EOS
  end

  test do
    assert_predicate bin/"sth-herdr-connector", :executable?
  end
end
