class Chunkah < Formula
  desc "OCI building tool for content-based layers"
  homepage "https://github.com/coreos/chunkah"
  url "https://github.com/coreos/chunkah/releases/download/v0.7.1/chunkah-0.7.1.tar.gz"
  sha256 "12c0101532e4c65cd63244f28ed801296df9d0a7302e3646026387f684fb690b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_linux:  "47481bef7c4bf109adfd92a921ea9963d79ebb5fda240dfe25d605c4cc48fee1"
    sha256 cellar: :any, x86_64_linux: "caa89d700f07b7751fe70b5b474ffe8d8f85c8919593f249b7840a259323fe4c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "openssl@4"
  depends_on "zlib-ng-compat"

  resource "homebrew-test-rootfs" do
    url "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.4-x86_64.tar.gz"
    sha256 "85498865362aa7ebececa0d725a2f2e4db7ac4e4b2850b8df21645afa0d03ee3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource("homebrew-test-rootfs").stage "rootfs"
    system bin/"chunkah", "build", "--rootfs", "rootfs", "--output", "output.tar"
    assert_path_exists testpath/"output.tar"
  end
end
