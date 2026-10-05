class Faker < Formula
  include Language::Python::Virtualenv

  desc "Python-based fake data generator"
  homepage "https://faker.readthedocs.io"
  url "https://github.com/joke2k/faker/archive/refs/tags/v40.41.0.tar.gz"
  sha256 "bfdc8770d8831de74dd8714f8837c05763ef7d7a3e782dcfe9fd90a6bff1e8c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0da5bc5bf51a3ae6885e7bc1e7863df2cf87248b06485d418e7259d983c6bc53"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{'ssn': '150-19-7120', 'name': 'Christian Blake'}",
                 shell_output("#{bin}/faker --seed 12345 profile ssn,name")
  end
end
