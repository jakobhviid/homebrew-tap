class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.38.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.38.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d68b86f3ad7a3c4f84a818495a301c4c675f8f6cc0193a62235123c4d19ea210"
    sha256 cellar: :any_skip_relocation, tahoe: "1e1551ea4e83113f922e7d433e82e20d2d65147ee9c4b5ede7df259db3874c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2e634b47403f84a858053bcb7fcfd7793e7de32c0355c00f7458e1fa8ad05c19"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "496ade0208d1e931f66aafd1328fc5f2b503df5f4a5bb34aeabbdc1d76f05ff4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9a27889959c445a71b8fe0b62bb38b7e9ec62eae1f564ea56985ebe10fb43515"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "39df6e43670b23ffeaddf3cc3a0798d8bb8bb5580a69507f47077381998fc7e6"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4b3811d6368a17bc3fa8eb5808f3c5701d47ee43c6b80a48bead873ecd57ab74"
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
