class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.1.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b17e38828f6a96e98c3b94576b7ee92a283614362a2ce67a1b22ab0a1d350e23"
    sha256 cellar: :any_skip_relocation, tahoe: "646429f5ee29fe76acde306161fe3e8c1d10290b01917b55181918aaa3f3b28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aecb7aac35a3406c8337d22352cbd6e79cf34a14a6e27ee436f03e1823893bb8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "1683212bae63dadd3396a59e58eacf57c5e4133de7c3cb4659a52665ab13ac8c"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "49d6cafc201e9a0989a42b14530ffaab4d843fc7c13e345bfd2cf88f1e3ba066"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a4b9e3400bd49bc024b7af1a1d6c8396b421c506f17212d72a419a682fe781a8"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d9da3b09d1662e8f6390644b43e0ba306a44f07254f041b33b7fd972c021325e"
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
