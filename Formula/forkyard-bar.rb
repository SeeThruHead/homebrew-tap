class ForkyardBar < Formula
  desc "Menu bar app for the forkyard daemon"
  homepage "https://github.com/SeeThruHead/forkyard-menubar"
  url "https://github.com/SeeThruHead/forkyard-menubar/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "48e85570a1c9899630989f5c38f805a0bd40a9f17bf96b1c667e119d2e0cd244"

  depends_on :macos

  def install
    with_env(VERSION: version.to_s) { system "sh", "scripts/bundle.sh" }
    prefix.install "build/ForkyardBar.app"
  end

  service do
    run [opt_prefix/"ForkyardBar.app/Contents/MacOS/ForkyardBar"]
    keep_alive successful_exit: false
    process_type :interactive
  end

  test do
    assert_predicate prefix/"ForkyardBar.app/Contents/MacOS/ForkyardBar", :executable?
  end
end
