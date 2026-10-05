class Texres < Formula
  desc "Fast TeX engine written in Rust"
  homepage "https://github.com/leoliu0/texres"
  url "https://github.com/leoliu0/texres/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "409217da635398634808f50b315e54b22833cc42da9a47c82318256da510c1f8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/leoliu0/texres.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "165ffdc831cc8fd89f0bcab19c3fde83fe7b9c4bd04d17001d7cbb7619ddb613"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de2ad22330910053c1bc10ca52eb90f426985253a2299bdd8e5e7220dfaffcc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b1f9fa61fe8401aaec5dbdc03410ad38df19b27df2415a9cd988d1f59db4e8a"
    sha256 cellar: :any,                 arm64_linux:       "639700e9ac453ecd820171050b0fa27c4789945fcb8040125657960b328642eb"
    sha256 cellar: :any,                 x86_64_linux:      "63e95511a419734b65c5e4fdb688b0df9278a44475b4b2605d1986cff4f99f01"
  end

  depends_on "rust" => :build

  conflicts_with "texlive", because: "both install `lualatex`, `pdflatex`, `xelatex` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "texres", *std_cargo_args(path: "crates/tex-cli")
    %w[latexdiff lualatex pdflatex ratex tex-bibtex texmk xelatex].each { |cmd| bin.install_symlink "texres" => cmd }
  end

  test do
    (testpath/"sample.tex").write <<~'LATEX'
      \documentclass{article}

      \title{Test}
      \author{Homebrew}
      \date{\today}

      \begin{document}
        \maketitle

        \section{Example!}

        This is simple \LaTeX file.

      \end{document}
    LATEX

    system bin/"texres", testpath/"sample.tex"

    assert_path_exists testpath/"sample.pdf"
  end
end
