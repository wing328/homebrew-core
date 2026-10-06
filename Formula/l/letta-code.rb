class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.34.4.tgz"
  sha256 "e0f8b65cb0f0216f10834f2af2d70bf9672b8226469c64ad944ff4f920bdb42e"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "b8874e611282b920a75ead3f6676c3238a018b1bef91a0bfc592de32f56975f9"
    sha256               arm64_tahoe:       "61336eb4430b89d7ac3759d0ef87cffa5f63cf5cdfd3814b9116577b9e3bbd11"
    sha256               arm64_sequoia:     "98b9294470e31cb7e9f70434cde4f0f522f30523199ec46610d1af53ca50e2d6"
    sha256 cellar: :any, arm64_linux:       "82f5d4a757374aa78ee0fc91834db327fc23af0a3c220b017f1731366cd9a85e"
    sha256 cellar: :any, x86_64_linux:      "f16cdbc4512a7fc3abeb7764266df1b8396560d4f132de8bd6aa2bce61ab6175"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove ripgrep pre-built binaries
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    rm_r(node_modules.glob("@vscode/ripgrep-*"))
    rm_r(node_modules/"@vscode/ripgrep") # keeping separate from previous rm_r to fail if missing

    # Remove Electron-only sharp fork with x86_64-only pre-built binaries
    rm_r(node_modules/"@janhapke")

    # Replace node-pty pre-built binaries
    cd node_modules/"node-pty" do
      rm_r(["prebuilds", "third_party"])
      system "npm", "run", "install"
    end

    # Replace sharp pre-built binaries
    rm_r(node_modules.glob("@img/sharp-*"))
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")

      # help letta.js find source-built sharp
      sharp = Pathname.pwd.glob("src/build/Release/sharp-*.node").first
      (node_modules/"@img"/sharp.basename(".node")).install_symlink sharp => "sharp.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Pinned agents: (none)", output
  end
end
