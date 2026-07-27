class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.9.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "73060988e8ade18c8b2d556649ab995abc202333c00341241e16197f260f349a"
    sha256 cellar: :any_skip_relocation, tahoe: "9181d6558955def31936cb3211c1778ad685e7457a5546dbe8ffd0038919962e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28decc418f241fa770a2a498df41f709a86a710f2cab66d9d07b854d065d04f8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.9.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "b0b94394fcf64d73dfa07c056a8088a6cbece3b0c9c83cb146774aabae47d69e"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.9.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "0dba982bc809bbcdc0c5331a2a5732603573ae32f6ed614206b36e339d7cc79e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.9.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "952171987bcfc6d6189b05d7aa1c09dd546f989ebd660bfe8cc84736440020af"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.9.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0200fb8333be616b420ca9a2e5fcb7d3b9b289e796126200e19099420aa2bcca"
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
