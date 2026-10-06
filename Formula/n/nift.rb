class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "5515bb3b2bde433ad8d572db6cf27783e584ec453912a9de5af1bbf71607498d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "500c33341b0d5497d34a15b5c02815a13b12f661b3ae0394f897b66558b73813"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af9e12db7812d72b294ddecf9c9e249f1a0ed4790f969956ec0fc429a6f59132"
    sha256 cellar: :any,                 arm64_sequoia:     "3beefb5066cf402232220fb40f3fe4f9be33ac20b8477405d287b7468d4b4804"
    sha256 cellar: :any,                 arm64_linux:       "1a40847acad071559aa9f42c1629398b4cf53382df6489fddc54d7c6d447437d"
    sha256 cellar: :any,                 x86_64_linux:      "1c5bff51340c10bc8293143e8a8d3da0ebe6c3a1033c729a08fe49f1b28883cb"
  end

  depends_on "python@3.14" => :build

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  deny_network_access!

  def install
    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      inreplace "Makefile", /^CXXFLAGS \?= /, "\\0-D_LIBCPP_DISABLE_AVAILABILITY "
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
