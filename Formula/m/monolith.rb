class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "71244b3cab7c74a5af9e40edbe4e9600fa78f46e0bd821510d4d236b7342bed5"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "321483dc6bff880e4bce08e34410cfe13d868b0f0a429bbd215ee0500f27ae39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cc06e04ca53493fd09fd578779708443416d6f2348cb7509dc8c92323380652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5adf6ad330c858fd009d55fbe792e064cdd10be0460c4d830a6fe86a3c7e439"
    sha256 cellar: :any,                 arm64_linux:       "2143571c71affe3cadd9efcc21c2477271c5a993f12196c851dbbb1379cc1b47"
    sha256 cellar: :any,                 x86_64_linux:      "deb95ddfa1807a1564cc949acfa88dbea77fc96ffd1a5ae71301bf305935810e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
