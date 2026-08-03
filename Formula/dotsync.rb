class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.1.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4e8564d1999bf8e7a68ae13f78f9e71124dd7c5a3573e55f52c09fce37e6978c"
    sha256 cellar: :any_skip_relocation, tahoe: "5acdf4b3ab714fcbfde641057b9121ff94d095bee1322ad41c6cec6b5a7dbb31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28baff3ae1dba4b6cc41b9987a4f699901d390c530ac99c588291d116f4afbb9"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.3/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "9f4251df998dbfe8a8fb453445eab28bc37643be74a5d653e880ce2f0c0b8f1a"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.3/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "786a32b8c6f438bead6c556217d1d508ca3f613c3310b8fc619b70bb3517fd34"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.3/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0ed4b8ca05b0762d13c29dc539aef0122abbea41e0249475eb51b3c771af898d"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.1.3/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ea60e76b0d0a54d7528fd4642aed3e5c6e2bac91d4bcf2fbba01e143e478b6e7"
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
