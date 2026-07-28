class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.17.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.17.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0ca32c06417266b7c92155b05c44f30bdb97353816eefe145c6770ba620d4a3b"
    sha256 cellar: :any_skip_relocation, tahoe: "1a20eca5b58998c5db52656b4c5606ec3a9d72dee35cbe7c7b5ca4ff7589685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d939941ad4b8510ff87b14140a48fcb2ff5bd51c840261254665a45c9bd5520a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.17.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "5b52bc5dce530634bafd06233c6e8b758791650317c5e2b5d33138083459b8ca"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.17.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1b3c9d86b01a8a524ae5e7e580b1ec51f0492657ea1808fcf49613fa7a1fbe84"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.17.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c888598924cc7ea9b46e52710cf73c55a86ad41eabeb6294cdaa0c9fdb126719"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.17.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c1c4c9d78f16cf7eb980eb845fdf738430c9a4b03205c92e5b9b748f8c1145f"
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
