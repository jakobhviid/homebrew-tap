class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e135e709993bf6f010be401cc257176562f0ced35a703183e59127707a15b5bf"
    sha256 cellar: :any_skip_relocation, tahoe: "cebb2d132606cd120e314d99ec4e8f5be04813ef76161253c452838fa552d3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "00ff7888aa797a37098e32538b1bc07172429305bd826a5ffdda7b2cc3fdf22c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.6/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "2b85783bc22d57f1d11d193994d99cda4f66a68dec5234eda9db4398a4328f6e"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.6/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "e76a24e6e8b3c8af0ad7a6f4ce4925a5c17bef255f8a092c78fc8b86476b2965"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.6/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f8378ce0a72774f10ff8be88cb546ad859d2af4c77194d4c6ce25d7706225b1a"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.6/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4267aec6742d3ab83eab4713e0f729514393930d57d14f529d96ec1a428fa9c7"
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
