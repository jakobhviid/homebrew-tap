class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "2.3.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5b2d7ba72d15dd05b4ba7a891e5d299e0473d8f5657a4984fcf5cbfc4b37af38"
    sha256 cellar: :any_skip_relocation, tahoe: "07231d911c169aa16ec37fb88fb0e757f8ed37a20a78098a73faa8aab6588185"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de2cab95e9a85dfdac79cd2fe3f03ed467130727431ee3996ad2a5966e470db4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.2/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "cc31753ae64de177db81637c02b09efcc3ed15ae7e354a1c907ef60576d6807b"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.2/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "34a47403ab257864bf2122975cfc4e3773e85e18ba1f1958e14bb59d082c850b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.2/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "efa8a512bdfa7fcbff42b51b3c8a8dbf00c88201f1367aa8912030187db53573"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v2.3.2/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1ad472a3891005c7bdc1f49da524b1654a519d2b85039df9dc08c9b1af939c4a"
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
