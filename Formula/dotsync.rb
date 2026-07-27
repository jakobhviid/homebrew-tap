class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.5.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5bad505d8054feb06f09963dc4bc7d021d3c91a225f9b1b251fed424bfc3167d"
    sha256 cellar: :any_skip_relocation, tahoe: "5c60327114b8a8d6085e7855dd4e49a9a222b49ad6224382e86968a536a05591"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a34099c4cf666cbd5c18286fc30c1b2b654081cc0c1b09be8c8a360f6c9f5afd"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.5.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "82c92fe41f62d8dcf1da8977c407447541be95df94191ed7dd24e4652cdb5a3a"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.5.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "6b97acf80749aaf34537dfb2450e0cd2bdb37e0dc3fcfa3e897850b70d4312c9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.5.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0250d86ca3d90287b495b31b57efb3f49cc66b207af3b912f3ca714641c1f0ce"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.5.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3e544b6f50adeee1f481d50c6b9193d53e392cb93918c9c42b6b0b059e202982"
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
