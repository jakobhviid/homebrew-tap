class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.10.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "06dca80dc325a5bfb16776d67c3320be803954c08c1afdde9e970a8d29f7d6a2"
    sha256 cellar: :any_skip_relocation, tahoe: "47b69016a6dda94bec8cfc858c8b683265097f2dc48f9498a7d083626f66137d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "251514d998d485e969098c2709707c32a07571bf208115c291cb54bbb30a04f8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "1291f97607e95dfca5e4755cf817c0032804d813f75092582705190095c2e623"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "65c3431d049c79c323f37e2f5074830af9ddf98595f2f29cfe31f9a76386aba6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4184dcc360b3ed7b12d478d7738ac6f906d72cc8eebf8a1aae0034fee97932a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fa0ffadc4319361a41f807c2a16d4342690bb69c1c49c26aeeace5872e590e76"
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
