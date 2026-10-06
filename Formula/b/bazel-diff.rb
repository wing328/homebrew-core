class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v49.3.0.tar.gz"
  sha256 "4eaf85b3f3fdb4da0ad333affe9dbc578e959c1c8d51bdd225ac58447e0cde12"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d1101cdad957ee6429fd7f37430d797e347e4e756642a7b74dd1d5f8fe56e24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d3a92a57e0405705596a30c5d8f07f0c9b27d7160bc70dfd59f8866f9904acd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24d17cd3b99f7b4ce7738625094e3f150c4edc5dc7f793878173e9e92f8516de"
    sha256 cellar: :any,                 arm64_linux:       "b60ec19d46781deef72ae39b5b44bf0c088b4e799732b87cdade9eaf7f90e882"
    sha256 cellar: :any,                 x86_64_linux:      "95bdaf459088d67b52584750ba7d9b558816ec070882591870e0ff1559f05c78"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use our protoc rather than the prebuilt one from `protoc-bin-vendored`
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"from.json").write <<~JSON
      {"//app:leaf": "Rule#old~old", "//app:top": "Rule#top~same"}
    JSON
    (testpath/"to.json").write <<~JSON
      {"//app:leaf": "Rule#new~new", "//app:top": "Rule#top~same"}
    JSON

    output = shell_output("#{bin}/bazel-diff get-impacted-targets --startingHashes from.json " \
                          "--finalHashes to.json --workspacePath #{testpath}")
    assert_equal "//app:leaf\n", output
  end
end
