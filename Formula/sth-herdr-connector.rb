class SthHerdrConnector < Formula
  desc "Connects this machine's agents (Herdr TUI, Herdr app, Claude Code, Codex, Pi) to a hub, outbound only"
  homepage "https://github.com/SeeThruHead/sth-herdr-connector"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.2.0/sth-herdr-connector-darwin-arm64"
      sha256 "766c1144fe2f9a911eccd41cbcd87908fd7d4038fdb843484f5aba4c3fdbaac5"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.2.0/sth-herdr-connector-darwin-x64"
      sha256 "68c56574bda5116c87797784285ed9e72d2b295ad30a6b7a7a321d6800034486"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.2.0/sth-herdr-connector-linux-arm64"
      sha256 "f914028440d45a6aa6173f55fdbf2c1f8508ccbe13276c29aa0e229e434cca80"
    end
    on_intel do
      url "https://github.com/SeeThruHead/sth-herdr-connector/releases/download/v0.2.0/sth-herdr-connector-linux-x64"
      sha256 "4ce3dfb75d5b1accd27fd4832f21c8ea8ba89fd01efd35ea7bc74c05c4468d46"
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
