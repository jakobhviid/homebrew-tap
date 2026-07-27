class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.8.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "805183aee193fc2b81fac0258ee51cf6b3a245e0a1ca457d9d3da90fcaed3857"
    sha256 cellar: :any_skip_relocation, tahoe: "0a035ce4894407ebc6c86ab493e0281b1687544950c280716a74c775aed7f703"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "12cbf81a715fcba549a88fbf0c219812fff97c9f983db8f8f79c18bf244c693b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "bbdc6dc185526f412020c1aab23d956224e407269a8383f147bddf7a23a84200"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "aa6a3b719bec53a7960888f5e2f43d4c4671d8e6711728744dc3e4c10a6ec266"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d6d5e554de2b4002a58d6f99387d794356790e844d104d874791081f3597f5f1"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec0f58faea5beda6af29d7a725f03ed7f83ca9fc7ebaffdd953ea0f649cbd059"
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
