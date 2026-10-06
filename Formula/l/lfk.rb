class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "64155c906096679b19f0e6e198c7b57409fe398a126dcf22dd5f771fa767c95d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e78a29112a5c164a2a5d95b6c826d107845c48902de3562f91fea846e35779fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e78a29112a5c164a2a5d95b6c826d107845c48902de3562f91fea846e35779fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e78a29112a5c164a2a5d95b6c826d107845c48902de3562f91fea846e35779fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "444d791cfa6ca5717f89b11473281add871c069dcae1adaf02ff5791de0823ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34b1c0f0fde8e0b7f9ae12bd72edeabfb317f0633c6e65bf2f621293fb730601"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
