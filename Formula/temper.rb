class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8a67c7b2791392678fd2cc3a470d9448e51812df3e987b71a5b9994471ff3de3"
    sha256 cellar: :any_skip_relocation, tahoe: "ce53e787b5daede83b73837c7f0bda81428b0e5a8856155c011a32562afadaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c82171452c0928e9465bb25ff7176223f54c2b39a214e2f59b8aa81e6b419100"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.3.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d5ce16c2af08d7811c192696f86ddcf58d51dbe8065dac62af180514a5e29840"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.3.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "5b5eaba7db79c6311b2c7e090d490f94d9351515d765c0496f48ff28d0a05c10"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.3.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a96bae5f34cada72d973c51fbe63eaaaf6b92831882261339e0a3fba2821cde5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.3.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "17feda2fb3d1c471d2df715cff29c58cae1cbce4ad0c1d954b6dc68b33a816f3"
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
