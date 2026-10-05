class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.50.15/doltlite-autoconf-0.50.15.tar.gz"
  sha256 "e91abce3c71f3f89a4b731d4afc4158ebdbe8e4787c0a7659d10800158d5438c"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bdf7a1af22c801b074fc8e9f39a3b88edf85abef2502cb42013cb9d57ee8e365"
    sha256 cellar: :any, arm64_tahoe:       "1e4d2bd31f0628bc6e2022b57d366c78b48c54cdfd913af5e648f1e6f12f7d7d"
    sha256 cellar: :any, arm64_sequoia:     "2e97276e10cb5c74e56477744ccd0aea346162107d74f5cb8c290bccc1d992b2"
    sha256 cellar: :any, arm64_linux:       "81f51087434bb83210b224d7ad8636adf6aa532885ea12ed85aea3d86771ae71"
    sha256 cellar: :any, x86_64_linux:      "b57e3c2f925b2431a765311a78d056d37985b8b70148f324785d275786e902d6"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
    # `make install` would also install `libsqlite3`, `sqlite3.h` and `sqlite3.1` from `sqlite`
    system "make", "install-shell-0", "install-doltlite-lib", "install-doltlite-headers"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")

    (testpath/"hello.c").write <<~'C'
      #include <stdio.h>
      #include "doltlite.h"
      int main(void) {
        sqlite3 *db;
        if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
        sqlite3_close(db);
        printf("ok\n");
        return 0;
      }
    C

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-ldoltlite", "-o", "hello"
    assert_equal "ok", shell_output("./hello").chomp
  end
end
