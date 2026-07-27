class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.8.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c1d103b5f81d8d7cc7485ed26da1a1fb2fc28e68461da144614d297768c2b28b"
    sha256 cellar: :any_skip_relocation, tahoe: "c2c905557c30370a4894ce553968b43d62f2b2ded6506cbf62a9c2906a8b9311"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "54b9b282fd345cfd0c6847310d94012ab370283f55c7a32a55c4e1a6cf919270"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "425e6edbe71255b7eb8995dabf75c1a9b46757d90ac47bccc7a14e7de79b3779"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "f55bb61ac52dd2f6384abf92d5e2486e7269e61504cb5b080fa0e5b0444c6a55"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e0d0ea1df66e175701a1021492e245392da10f5bb02bb7df422fb7f504b1fc3b"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.8.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7c96f1d9c0e326c95556a37f3d20a020079940f7f33db0643a6eeb202896f5cf"
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
