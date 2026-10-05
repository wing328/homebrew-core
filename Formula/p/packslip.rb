class Packslip < Formula
  desc "Signed release manifest for vendor binaries"
  homepage "https://packslip.dev"
  url "https://github.com/jdx/packslip/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "7b4e22b0d43878bcc28ff703f9b90a03a38b38d3f825ef2b996e5557ef4dc15a"
  license "MIT"
  head "https://github.com/jdx/packslip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "227f4928ce56c025a0d32a2a7fc6b427c3e1d0deba09cc07c6cef8009a4a595b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a873963b71998c91f139e401cef7d96da6d0b33879d508bddcccb7ee7fdb4581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "009579fa44c548c988c2513e0b7a7da52bf126403c4b93dc20c98ee455e93c19"
    sha256 cellar: :any,                 arm64_linux:       "020018446e6045c53d19ccaf110a66f44479d583e4abe5818b0ad93b0367cdc0"
    sha256 cellar: :any,                 x86_64_linux:      "8617b75ddc1c55038e6fbb2ca8ec1a5499af7ab231e67642313fb598197d43a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"packslip", "completion")
    man1.install "packslip.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/packslip --version")

    system bin/"packslip", "keygen", "--out", "brew.key"
    (testpath/"brewtest").write "brewed"
    system "tar", "-czf", "brewtest-1.0.0-linux-x64.tar.gz", "brewtest"
    system bin/"packslip", "create", "--project", "example.com/brewtest", "--version", "1.0.0",
           "--key", "brew.key", "--no-log", "--url-base", "https://example.com/1.0.0",
           "--bin", "brewtest", "--out", "dist", "brewtest-1.0.0-linux-x64.tar.gz"

    output = shell_output("#{bin}/packslip verify --pubkey brew.pub --allow-unlogged " \
                          "--artifact brewtest-1.0.0-linux-x64.tar.gz dist/packslip.sigstore.json")
    assert_match "ok: example.com/brewtest 1.0.0", output
  end
end
