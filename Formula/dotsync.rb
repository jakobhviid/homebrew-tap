class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "31b56d71fae74f7ac83b0f73148f606ab1a91ee6f0e01365ec0c612b8f591402"
    sha256 cellar: :any_skip_relocation, tahoe: "105182589825087d56719b9bdf65ba67d283211d2ee7e1552b930a4f1508debb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "46d6121ac876473ede8cecfe51fa68de9583469c14e4b34ea687aa9ae5093542"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "1900e45c93b77f6d9cd6e84e5f4b9b42ec4083a33ad0271aa8d9d28cb8a90c65"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "c81e2769625ce65da344187e462404c2aea4be0d4b39d298aa943a00c51f51ef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "feb01b9a2ffcc7b0f3be7299267a72d1d1800482763bfc4c119d366f5b6668ae"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0e9da841cc2bffb2da89119f312e50ee2ef9790ce66fd8c12c86841820707852"
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
