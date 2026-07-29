class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.34.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.34.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "234dce73a9babca6d9b8dd8aea05df54991d5d17c4ca3fde9c8bab8bc0bcb941"
    sha256 cellar: :any_skip_relocation, tahoe: "494c20f2d49fccd72859e3f60c68fc999d62307a980ae634b565bd9578619ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b43843e282912e512b4333e5cce1521b3bbe1e249810ca960080d0daec5522b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.34.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "f128774d3623a5cf9af4717402880a89a240f35632ea58caf5332399a055ad82"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.34.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "afefcc64855cc95d2b041ffbed5f14a6423dd1a5213d516b6b2b1c7df7f198f1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.34.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b8c663ec10bec6ade98f63f66af484fa9cfb87891a8fd02dc083f8ba1d2f6b49"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.34.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a4552c48c1ecc20ab17df4d791bff2a50c49da7513318ccb545342aa7882f624"
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
