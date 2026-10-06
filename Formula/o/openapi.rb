class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.25.5.tar.gz"
  sha256 "9990f7d8ec48f1479815153c45abf73e77491a635025d2f9add1a9bc75ff0c2c"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c63ddb9945c43a455bd62058c2d5bffc4eb8355fe94200f9495c1dd7b053fecd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c63ddb9945c43a455bd62058c2d5bffc4eb8355fe94200f9495c1dd7b053fecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c63ddb9945c43a455bd62058c2d5bffc4eb8355fe94200f9495c1dd7b053fecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08c5c3808134e206011fac007ba44465f87fa35ff166d82255f49d94d3b096f9"
    sha256 cellar: :any,                 x86_64_linux:      "c0f2938c43471cac5930fd814387b44df4a8bf3b4d6d9ea67f0fbfaaf9d24ce4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
