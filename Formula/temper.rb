class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7506f2ec0fc05c04cfd82040b9b1365537863a6245c250083e7e16785fecd1e1"
    sha256 cellar: :any_skip_relocation, tahoe: "06f4f4d29536b00c871edeadc4011ad6452246c13a8b3a2dc6865cdd4a1912f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52976f6e0296821ef5cc53459bc025b0136f761f96785d9d9cb49922df768d42"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "04699a39c06d25da4d767bac5b9cdfaa8498315c9aed5fcf0a30eec95b89e55d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f10987ffa9e31b2fcd98a57161fb4a2a24f14b88655808f157b68d32bcd0f716"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ae0d618e4e6d8f9242f9362e7abdb78157fca912b011901f9bba2a2198dda7fb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d47b03e67117570141fafafab0e62a51f5dbd48012227c783be86aa5117e89a4"
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
