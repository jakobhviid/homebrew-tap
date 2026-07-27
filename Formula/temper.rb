class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "85fbfeeacaebf31d731ca0cd18468927763254be72d4c7bccdcea9fc99daeb8a"
    sha256 cellar: :any_skip_relocation, tahoe: "05bb8f39043d04f03b5b800e7a6f13f514eebda8d62bfe15fbffb602745f3a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2184345a451cc6f4c897fb6d4b6a91070471884f03a67edca6d16e41fd38b0a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "81c3bcd7c5ce4c1b857e5ab1afe7dbd52792039058993827e1e41878e74851cf"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "b9c45a00e896577cf3d2a80511baa9dd15c92fae9cc1b9ba9501b35ea7ff7088"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "14c06c42e8cf7166aed94745e799f25f0e479964106cef679158a1ef8c360ded"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "76e7ca8fbf58b5003238c1ac943afe9520dcc85938fea2a9f41be67cdf8f0cbd"
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
