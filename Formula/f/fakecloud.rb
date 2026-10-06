class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "de69eba9cd8e6a856eab7405c85c01b4182e2495d3ddd96df0a0cb2cb86b9ea2"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cff5a4471bbc76bf68b2f53b1b2273c1726d599b275de36955ea0bb5377b728b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39e7cb816186a24ae0b55d4940aaf9692029b88e79a77adfeb2263a653e6549e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11cf7afe355a5bc0e70b754ed0e3057705a81ba773927db296c6919b625f5b4e"
    sha256 cellar: :any,                 arm64_linux:       "a67b7ca2d283b6336204b073ce9b0231cbe5fc2d5b6ffa3bfd881b29c2e6f836"
    sha256 cellar: :any,                 x86_64_linux:      "6749bcfcab30308f7feea50cb7ad244bdc09ce9be39167121da16961b89085d8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
