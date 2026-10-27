class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.9.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.9.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "901f962130dacf41c3ce4743d42f43d86e1b7b59570ecc8bdcfcbc80fdf1a52d"
    sha256 cellar: :any_skip_relocation, tahoe: "5dcf1d27a5659bc258448ccf92df020b372b7782a4f2670e08802e34b642b658"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a57eb684656c4d216cb81ca910474fba4cdc51198322a2d2da6b183c7ea59249"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d3436144518f8e9c76652b90db1ae2abdb42fb04e88530f5e1997d154507f6a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "2d8eb299999c05e1f44b982d8ab91444ba4f2b4941ef6c25563218738df65529"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f0a3ab4e26ffc590bda3c31fdc60a1e6889e8e6b5d4318eea52d12ae438cab4e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.9.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "962ff6613054616a93fdc6fe8926e25e42c32977a9c5d231a2ae2ceed88e10a9"
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
