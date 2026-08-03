class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "02d426c3c3d59114f222d76ae81bdbb1b5c8b42a9fbc724b7875d345ce95044d"
    sha256 cellar: :any_skip_relocation, tahoe: "a65aed751bc301ce8fe0ce61626c82b91806a1d5738b319705104da405e0aa2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10ea9ed3980bceff6184d1902cf313abb8c4a187cd420f08293f32c3df319eaa"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.5/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "b1f1f5ae498d30ff691b9fcf8563e4096f6c565465c532ebec176dd17f3eb67e"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.5/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "116a0cf3e529ae40f9e948e8f1a31c7b05baf37a41a64635d6dfd04499046810"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.5/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6eecd8a0d55b3f8be130daff42a7980673435cfbcec197be6823413eeb69e07d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.5/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2360c4cbb9c649766f61326635981c850e2d16b65a66dfb10e058a5a8b410ed9"
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
