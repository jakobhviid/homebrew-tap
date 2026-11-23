class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.11.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.11.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d34ccb92b9ddaf038f4443fad0537af7395371de317b4250c9e07c927a5f46bc"
    sha256 cellar: :any_skip_relocation, tahoe: "646c472d4568690b275e6fab470b40688b91d1e547c682897ddbcaa28e671cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4679b45282a9976d5161d24331bea8969bb052abe9c981e6e9502114aaf494a8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3474633440580845ac695286250d2ea92232d5b45267870946085510c18e36f6"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ee77a728a2b2e678ebdb0501ace13a135dca3a2278e22a1849b1482b9b338ab6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1fce7c51084c115c15aa8685c3279defe1e6d52e7354f28e38251d00d0cfa6e5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.11.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ad4ede5f89136e6002302ed7db0991cdcc6853806c596dfc4bc45fa3f71cd518"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "--man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
