class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.13"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e9e61b2c840c81af876601ad092987d7453a809e7db988ac40cf51e696114807"
    sha256 cellar: :any_skip_relocation, tahoe: "ae336aa0850a95f60c3beac52f3331ea3f11f0240d40dfb32a6a9479832b8558"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6313851bae0531741ccc5b03c4b500654d4b4a538bb2e3ab57a7273d98f2b25d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.13/temper-x86_64-apple-darwin.tar.gz"
      sha256 "212828070c41cb2c7e96540823f73d577789691c423b9f3fda9cf860621a07c1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.13/temper-aarch64-apple-darwin.tar.gz"
      sha256 "0cf65db298c4965b21ae66ddf90fb2fa50d818e186d23b600abc439bc3ad1dea"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.13/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "434f48387001e2f8616ac001d905f24d5cfefb92d7b8d901efac548dae648966"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.13/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cacfe0fed1d99137f789b08c55d852da2c00fc99cd90fdf823da267118da4527"
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
