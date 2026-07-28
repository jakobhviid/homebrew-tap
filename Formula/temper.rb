class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.32.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.32.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "856fdd1b4cd65cb99e6e0966f17526f70ede9b1897f15c70a42f36a46b09707f"
    sha256 cellar: :any_skip_relocation, tahoe: "7aca03bc9b6bb3fb9289809f63ad792ef13ae324f0648f48d445d9b7d93bb92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "becf710ea425904c756fdd1117b0f2f26c1f59eaee33b3338f2faad1e2eb7711"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "4a8345e5274e0e0ba987a576821d90bb2caf517af2f7f92430b05424847624f1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f6d15b78f02c1bd43d2ced2f9182d7b28d6247a47a620797bedd69aef0f8460d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8d5dfe2f64f7f9565a0c05317327eec6f199be1a7a7aab434c493fb6a48f9e11"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.32.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c40829dec35886181d5fffa45f66d8a40ebe9808067f3a6317bb2000e7ea923e"
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
