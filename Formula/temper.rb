class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "eab912d9965793b1be3aa8d59b5d7b72ff244331d9392d21115859b545c9e84d"
    sha256 cellar: :any_skip_relocation, tahoe: "ff90e086c06e52db31875bf724afa67cf6ccf938c1f2c707f8cd6d36867e5dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8d8801ad18c325ed6763407fe8776f762d93968e4243ffe1ecc056e7ba001622"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "7b25847fa502e962763fcd9fd2a034b3914491292cd49e2460f9a19ae42446e4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "182f6bc86844da790de284f8099c46b594be09d72eeb428c6d53f602688ddf12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3e2146bc3082cfbe99351116141cfe676987211db8c36da13ec3df47926d474e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4d02513367e8507dc807270c47f3c4a95f24359db06ac6a4c04005917acd1749"
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
