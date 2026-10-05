class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "2792acb650342d2d6e9071813891477b7b4b9a3fb4cadec6ea49a14f5898a72c"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "518076850a165db162bfa909e87c3ff277f172e1be5aca4248a050358a7e70f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f30215f882c55c623d15c474525c4d3f2e7711080d46ab450fc6b0203d86735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87323e859a59c167bb3e92699ddb6cbde0c761f45a8d76ecad77cb4ed65752c9"
    sha256 cellar: :any,                 arm64_linux:       "689723bb8d2eb408802e62a6d98a8d5eae84a987c9e53d302ba21cf3cad13b85"
    sha256 cellar: :any,                 x86_64_linux:      "78bf66438ce39f1dd21bd892fec158624caed618f2198fc3465b3c26d353b5cf"
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
