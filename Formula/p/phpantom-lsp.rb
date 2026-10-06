class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/0.11.0.tar.gz"
  sha256 "af15e4f73b510f6d00bf2ce1a01e6d1610c15c18547f8bd987c64be571782475"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0207cae84bb759b63321314ce41f5aacde6a4792f9c3eb574a5f32650b3a065f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b15b8685a8cd181a734e8babc1b661d0d6bf1cf49b4216c6bd34932ae6043ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5322eee5fbd3f0b44434301c1a169bc7ab4771c57232e6f6a6c457b3524739e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c2870b8578fceec6f0c8b610e870ae9fd8cef009ab7e12cb6c2a307290079ddc"
    sha256 cellar: :any_skip_relocation, sonoma:            "2bd3c076d25c410d9d2650fbfa3423dbef3850b0dfd044165c57619a687e8a9d"
    sha256 cellar: :any,                 arm64_linux:       "a627a2224491982b0e3bdae35f9568eee6cf0f85634238c8ee5982a78fe4f8cb"
    sha256 cellar: :any,                 x86_64_linux:      "d8df93c7a0c2358ff85799943aee3f42ff2f0ca3e12b6d37ad88d27f623ae67b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/phpantom_lsp --stdio 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
