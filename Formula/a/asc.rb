class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.11.0.tar.gz"
  sha256 "3d71138dd70c58ace796c5c27944177102682e5f1e576c22f5e0bf8d26c2b7aa"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e17349ead02c234fe46e5064050c8c5aaa2d567fe42bf929aa6016cc549b910"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "570c12dda245bd1e88c8644f504a2ee5c04da57c75ea7b41a0dfcfafb2c380de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5a037103313d07db3848030b99b5f60ff6f394fd972ab668710f7af562cbc27"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afb2c174f6c3537cadef46fe7dc7ddb236d606bf39d9a91e32468d11667ec7f6"
    sha256 cellar: :any,                 x86_64_linux:      "e1ed0e1ad79eaa49fbba7ddcdf6ed1d1cf16cb6f06e198a8522b1501280a0e9e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
