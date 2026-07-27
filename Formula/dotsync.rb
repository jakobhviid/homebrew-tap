class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.8.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "052576d1b194a03f198cf214b60afc3b357d6d6732bc62d9cacf82f7a4f271c5"
    sha256 cellar: :any_skip_relocation, tahoe: "67fbe205df7807b07e4d01a1b600d7816a9c23ab3e0e5f240063de0512cbffd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a33f56bbe995ed740fbf9bc8812aff66cd04000043c65f68a3f7a2299c4485e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "db08c9b0bcd6974f746fb4ee538a2c8e4b6462252798df700343871bbe44d62c"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "e79d509d242436e4ebd6767d162285ddcd19eaeab149883d21e3f624650dade9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1b39f2c88e892ed9910ec862e8cfacb5c4abaf11785d933128813fcadd4740d4"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a403cc4799f01c738f8f07018f33c5556ada97b9e74a57f01450a9065d269ed6"
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
