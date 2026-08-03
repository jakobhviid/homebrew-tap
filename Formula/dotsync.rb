class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.2.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2191808a7f7673f71b7cc48abfdf571dd55c32a3e4394208370e14f09a9c290c"
    sha256 cellar: :any_skip_relocation, tahoe: "5cd58ba3b7849fd1e28dd4c07f5ef4f6a1d1e885052a860f754d1b4ae98a5c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7523d4c70182cbb14bbbb485c79d35841a676ba6ff396cbbff3256fd39eb2e06"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "496b490ecc8c9d02cc817c0cd308ad68a7423112ca2536f6860a4da3e6c628d9"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "be85fb2eedaa7d1b73eecebe0bb5028f23a28b4f6ddad90acb2b1a74aa02627d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "54d86f3b62e3396d847e397f09538c1f8d02e7ba6e70d16be9fa8904ea18edca"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "452ed32b1080d67e4318f685300110527c8576a7a3bb32e52b3a3a274f7d1712"
    end
  end

  def install
    bin.install "dotsync"
    generate_completions_from_executable(bin/"dotsync", "completions")
    (man1/"dotsync.1").write Utils.safe_popen_read(bin/"dotsync", "man")
  end

  test do
    assert_match "dotsync", shell_output("#{bin}/dotsync --help")
  end
end
