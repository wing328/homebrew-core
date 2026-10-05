class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://docs.basedpyright.com"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.40.2.tgz"
  sha256 "5d1073a0e61a1adc6b40b2bed4489017aa5c1336aa8e6fdcb7157b9bf26f3fab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b58fbdd60d75d8f8e7cb03163c00706c6e66ff19a8d7342aae724b9ca302a501"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
