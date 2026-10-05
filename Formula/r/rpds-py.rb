class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/42/68/3bd46b8a5e01d3c2ebdf9c5e9497912e3fe0cde02bac21a7130ca866e403/rpds_py-2026.9.1.tar.gz"
  sha256 "4793ef7f78268b124b73fa933440f01d258bbae01de9fa53e9080c9ab0425a12"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f6044ecf46de87640184e0c2ee600fd5656c606e977682efb3b89412adf43fc8"
    sha256 cellar: :any, arm64_tahoe:       "263f26952c943f8704b81c9d02de7f744f0482537c9b99cf38af8159dd3f880d"
    sha256 cellar: :any, arm64_sequoia:     "659f5e783e028cf5ea05b913597226d7de497c63117440f8957faae3e57fe10f"
    sha256 cellar: :any, arm64_sonoma:      "65f0b0a05280247f885ac4fd00526870f00d25a483f3b254acd63ffd2aa2722d"
    sha256 cellar: :any, sonoma:            "3fe3248e249a5fc2bbebbc6cb25b2a5d70a8b9095bfadb27ab84de9c60167ae6"
    sha256 cellar: :any, arm64_linux:       "58af52827af49ff40a20fa7db4dbd254fb2f9d58c6729e30c0d79340d614e88e"
    sha256 cellar: :any, x86_64_linux:      "4a2d9a2c14fbe07e34f533e18133f1faee06edd1a648c61d261c77ae3d743ed2"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    PYTHON

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
