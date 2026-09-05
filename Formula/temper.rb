class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.2.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.2.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "43f55a10988ad018777b951635cba30dde44d7c543a51594133ac568af74b45c"
    sha256 cellar: :any_skip_relocation, tahoe: "03d48d030d778e5753ecf034197bf62b9faae08089b7e8aacd9841a335c2a0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "836e9e94f2a0d9e4ebad6fdc975537cce85453d0e66a28682957536c28d864db"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "4acb3770249eda65a23947c39bc2ffc9783e1b9d79d66c98dd93aea5e9b51be4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6e7f6e072ff81eea6804414a0a5d7ce5078a16063589aab4b04fff6045e4df8d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e35c27dc3a4a6508958b2a956bd4aca2c112e239f5778fa5e9333d2ebd37de63"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5a06fecd1a2e252e0889393c5d37d6a9e8177cdb21005109dc4c57ca4ca07714"
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
