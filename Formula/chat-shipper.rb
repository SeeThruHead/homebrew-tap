class ChatShipper < Formula
  desc "Ships AI chat history from every harness on a machine to an HTTP endpoint"
  homepage "https://gitea.sthloc.vip/sth/chat-shipper"
  url "https://gitea.sthloc.vip/sth/chat-shipper/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "94b83fc3fdc2b53eb1eae548e5b6ef6871fdca73446f23a1c2f87d9ea7cf1111"
  license "MIT"

  depends_on "seethruhead/tap/aihist"

  on_macos do
    depends_on "oven-sh/bun/bun" => :build
  end

  on_linux do
    depends_on "bun" => :build
  end

  def install
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    cd "apps/shipper" do
      system "bun", "build", "--compile", "src/main.ts", "--outfile", "chat-shipper"
      bin.install "chat-shipper"
    end
  end

  service do
    run [opt_bin/"chat-shipper", "run"]
    keep_alive true
    environment_variables PATH: "#{std_service_path_env}:#{Dir.home}/.local/bin"
    log_path var/"log/chat-shipper.log"
    error_log_path var/"log/chat-shipper.log"
  end

  def caveats
    <<~EOS
      chat-shipper needs a config file before it can send anything:
        ~/.config/chat-shipper/config.json
      with at least an endpoint url and a format (the README has every key and the
      built-in formats). A token, if the endpoint wants one, goes in its own file (mode 600)
      that the config names.

      Then start it, and it sends what is new every few minutes:
        brew services start seethruhead/tap/chat-shipper

      chat-shipper status   where it sends and how far it has got
      chat-shipper once     one pass now

      The source downloads from the homelab's Gitea, so this installs only on the LAN.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chat-shipper --version")
  end
end
