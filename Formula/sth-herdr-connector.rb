class SthHerdrConnector < Formula
  desc "Links this machine's Herdr to the sth-herdr hub, outbound only, for the phone and web app"
  homepage "https://gitea.sthloc.vip/sth/sth-herdr"
  url "ssh://git@gitea.sthloc.vip:2223/sth/sth-herdr.git",
      using:    :git,
      tag:      "connector-v0.1.0",
      revision: "d82e5725b77df1b67da54874acf360854ab9b559"
  version "0.1.0"

  on_macos do
    depends_on "oven-sh/bun/bun" => :build
  end

  on_linux do
    depends_on "bun" => :build
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    system "bun", "build", "--compile", "apps/connector/src/app/server.ts", "--outfile", "sth-herdr-connector"
    if OS.mac?
      system "codesign", "--remove-signature", "sth-herdr-connector"
      system "codesign", "--force", "--sign", "-", "sth-herdr-connector"
    end
    bin.install "sth-herdr-connector"
  end

  service do
    run [opt_bin/"sth-herdr-connector"]
    keep_alive true
    environment_variables PATH:          "#{std_service_path_env}:#{Dir.home}/.local/bin",
                          HERDR_HUB_URL: "wss://herdr.sthloc.vip/connector"
    log_path var/"log/sth-herdr-connector.log"
    error_log_path var/"log/sth-herdr-connector.log"
  end

  def caveats
    <<~EOS
      The connector reads its hub token from ~/.config/sth-herdr/token (mode 600; its hash is
      in the homelab's sth-herdr.yaml) and finds herdr on the service PATH. Start it with:
        brew services start sth-herdr-connector
      It does not update itself when installed by brew; `brew upgrade sth-herdr-connector`
      and `brew services restart sth-herdr-connector` bring a new release.
    EOS
  end

  test do
    assert_predicate bin/"sth-herdr-connector", :executable?
  end
end
