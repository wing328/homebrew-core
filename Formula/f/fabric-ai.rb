class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.515.tar.gz"
  sha256 "71c3f346628caa706b06ccc4d3ac6da5086c6e3b3a6958f532de6024a2558a93"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54651309514b853f500c3e0d083a358b39e4774135946c929db4105ca5f811d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54651309514b853f500c3e0d083a358b39e4774135946c929db4105ca5f811d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54651309514b853f500c3e0d083a358b39e4774135946c929db4105ca5f811d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "667eadf6d93f5e0b54c76302ddb8691e0282ff2a858920122b4a3f812914d181"
    sha256 cellar: :any,                 x86_64_linux:      "8ba363f0fe644ddafc67138c90748df574a03c7983f36caf7c3d67b8e3e6fbad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
