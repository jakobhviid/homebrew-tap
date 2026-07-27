class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.3.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ecbe7c90a5a45568948c06541c99a7a8086d6b8fb768eaa43b8d39b4e01b8db7"
    sha256 cellar: :any_skip_relocation, tahoe: "c520ce5526796e65c01c2dc7b4e4054faf762ef47c9f96e2a4bc214699ac2a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2e5f226dd7ccebf383d875a91ee37fd96098c7f0fa8be676382d36c3597a4ac"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "c170168df448a60a32a49349cd1ae8f9ea016c0d54889995472b03337f51055d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "c61edfe44b526d44c23377992906c3f77c62df0ff9a384376fbee7b92fcef055"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cd6b5efaafdf0371c0d8ba543821c90a1b704885b863b57a677be33d6562c15f"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.3.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0c4fee8e35b1be874c3ff22434e57a2f61a08baac95389324043ca8abd5aaac1"
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
