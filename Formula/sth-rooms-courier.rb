class SthRoomsCourier < Formula
  desc "Wakes agents on this machine when they are mentioned in the agent rooms"
  homepage "https://gitea.sthloc.vip/sth/sth-rooms"
  url "https://gitea.sthloc.vip/sth/sth-rooms/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "02ec216587dc824806c1072a45d28e7ec245406c8156050eaa2161d8b8bcfb5d"
  license "MIT"

  depends_on "seethruhead/tap/reach"
  depends_on "seethruhead/tap/sth-mcp"

  on_macos do
    depends_on "oven-sh/bun/bun" => :build
  end

  on_linux do
    depends_on "bun" => :build
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    cd "apps/courier" do
      system "bun", "build", "--compile", "src/main.ts", "--outfile", "sth-rooms-courier"
      bin.install "sth-rooms-courier"
    end
  end

  service do
    run [opt_bin/"sth-rooms-courier", "run"]
    keep_alive true
    environment_variables PATH:                        "#{std_service_path_env}:#{Dir.home}/.local/bin",
                          OTEL_EXPORTER_OTLP_ENDPOINT: "http://192.168.0.29:4318"
    log_path var/"log/sth-rooms-courier.log"
    error_log_path var/"log/sth-rooms-courier.log"
  end

  def caveats
    <<~EOS
      The courier names its machine from ~/.config/sth-rooms/machine, else the hostname in
      lower case. Write the name Herdr and reach use for this machine there if they differ:
        mkdir -p ~/.config/sth-rooms && echo mac-mini > ~/.config/sth-rooms/machine

      Then start it:
        brew services start seethruhead/tap/sth-rooms-courier

      sth-rooms-courier once   one pass now: report agents, deliver what is waiting

      The source downloads from the homelab's Gitea, so this installs only on the LAN.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sth-rooms-courier --version")
  end
end
