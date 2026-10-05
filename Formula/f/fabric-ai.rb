class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.513.tar.gz"
  sha256 "5577ab06493c1ed4ce20599d613ce6e0d176a345f93cd4d33dfe8ce7384f2d91"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3eb1fd363824e484e14b34113536cb86e63da9966d66d2f035e9badb934760c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3eb1fd363824e484e14b34113536cb86e63da9966d66d2f035e9badb934760c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3eb1fd363824e484e14b34113536cb86e63da9966d66d2f035e9badb934760c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e573cf29d6b1ac793b2fd0ceb5401290a27370754ce6122ba179c854cbc2f018"
    sha256 cellar: :any,                 x86_64_linux:      "d66ead097afe890f7fbf05a805c600b3a4c57b2695798ec8ead91454e10def0e"
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
