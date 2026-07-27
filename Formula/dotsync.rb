class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.4.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e55941a909c7210cccd76ba676a01a917a61b97051d780fd48cef8a03543abe1"
    sha256 cellar: :any_skip_relocation, tahoe: "70cddeecae8407fb4c770aec7bd80e17888514795c8c89880454e095c5f3b918"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f15065cb54e443e256429f8715c55e0c86fa8131b7d9997c94e3fb1f91a6620"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "a7e472232940501d827057cf6795bb9004fc40fd2d6ca26ce55ccc1812d33156"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "f8294454da613c82751ead75c941ccfe5c3790d9c9773515c9260b356b82b852"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9df74f59c1a3f519883dbc023be8645843ffa2d77a33c0279a73b0471eb17503"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.4.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d13708fef9493f8adae3335b0d206328d519798fd94004d04bb9357abd9f0ca7"
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
