class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.2.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ec206b1f77848e3975796bbc024e9522781fdbf2c8f6c1c48b8ab3806cae3dd7"
    sha256 cellar: :any_skip_relocation, tahoe: "e13f8694a07550531cc75b1925d8a780c4b31fc7d99b54f387f2c734f4b1321f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b2f9cd09a5ecf4b8810206fc208a136203a373a40e2bc78552f11eecb3e52e14"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "f1ef33be3b98fe4d085d2d4d109ce28d3a9fc0b9d07605c20fc05a8da9e4c91d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "3620a561c6327b44dc4bf37af71838165035d4043c83fed14a122466507d947c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "094556fc73620d8a4ae4b64455b6041e69c9588e1aa178e57e8ddf28669c223d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.2.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1fe7417696f4ec3023ffeecd05ec06123a8577c25e426e58c28e53a4bfcaccea"
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
