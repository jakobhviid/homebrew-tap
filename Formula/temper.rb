class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.4.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dec8d4b514cfe9a1b3944f1730851eca8820e95a8fc1c234b8ae0eaa7697bc03"
    sha256 cellar: :any_skip_relocation, tahoe: "9faa27533e4a57b4a265f692dd751735013388967e5a490dfe424e46594e7e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abf58516c6744addfae0cfc6a5cee49903ee221e1e36f1293b8dedb9b5c3552f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "f5775580a76b605af86109c6a3b6545a64d18041b9cae6342a5db9b1ef05fd75"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "efc61d95ead458d928c21d38ea10903c550a975b2ba60706221867840e892215"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "708b18ad1d759389446e8444682d2f5aa9b48c1784759a9f1b976155e4af36a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.4.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b661863a292c574282a72a304dd24f230fc46f66485deca605c7dce98b33f30f"
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
