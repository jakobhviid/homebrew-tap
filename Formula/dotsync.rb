class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f5f969d7be8ab4b67e85cfa6a55f80a43a40bac0d7d207cfd1e94d1fb295f68e"
    sha256 cellar: :any_skip_relocation, tahoe: "b77e4a882a616deaaaf83022ed458a4d7a60d574951cfdb3632ea601cb27276d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0d03bf0373660dd7a482999e22ffd3e667b0db6cec363b94d1e4c118b813507d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "5dba600a9418d84651f2a1ec9ae86ae06b38088cfca652b8fd2a5d7662f2fc78"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "822f7b553b29b67d9a04027c6eb40eed35639c0264620f3098fd9060c6c06c41"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ff0ac92b3165a1c2885fa9130a3ac3c94c6d0b76f08feca13647dfa058410550"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2bb3fb39d01713a2ff0cc4b3c0671f25ffe75ada62d30707d95c6486a55c9428"
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
