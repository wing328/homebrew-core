class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.32.1.tar.gz"
  sha256 "5a178bd7e914df95885b94d0945a88a62fa77572723edcc5ae5fb3f97d38c3e3"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39b4977891d8cb9f67d9de98039b4004b1842966fb2b4e949ef5f7f81a2a038c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97528023ecae2734580b3141c59e7246cd0d78645e6f71544127b5804b3f58a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "138a53a9d270a01e67ac1adaf00140c07988044ea06878fa2de0464baeea1933"
    sha256 cellar: :any,                 arm64_linux:       "d06a35463c1c3034b46c70e0eb5251376b87f710bb653255dc5144fec941109a"
    sha256 cellar: :any,                 x86_64_linux:      "3178cd35081a15008b6d6b11c3c28919b2a3e29748be8310f8807b37373c568f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
