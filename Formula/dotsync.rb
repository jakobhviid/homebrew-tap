class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.10.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b3bc60217e3863acc70ed0343e1a706e92b3686dc7346b715c9a4aab6aa4d188"
    sha256 cellar: :any_skip_relocation, tahoe: "6218fa4e4e2ba0db52dcf49dfcaf7be5220fce3d637065d938a4690a745d8356"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c0698fd816e35151103bdb334eace69c911315a40456f6fe874d191b0be87e56"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.3/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "8417a9cdc4f783ce1b06ceb9d8bc4f4e01453597176789d27362702071e9fbbb"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.3/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "8b8d6ccef2bfda15693e7bb51e168e10ecb6e8102f075d6692f7750a4afb1132"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.3/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "28fdfc43d3cd5c744335c7d0e6e0a0df93787f523503d7add3277e1eb73bc063"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.3/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1a75433571920baf3089737b80fedd6734a9f28aa1a063ff01d6b29725480413"
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
