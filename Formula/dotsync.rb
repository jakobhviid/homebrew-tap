class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.10.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "420f77644a4d93e05766a768de13693c7559c2dc520c940cd26e8436a4a889a0"
    sha256 cellar: :any_skip_relocation, tahoe: "eae96036aa1a6ec8831389b640a8c12360298f2cae1304665c779f953ab15f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6df503d26cf4f8ad1d841c69593c0d38d74aa4fc2b306f18ba6af586fdff424"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.1/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "97896d667e0fecd1256afa73c43f2ddfa91b7a353b6ae0db38fb9207975e64e1"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.1/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "59a8ae035c0d1ce0731ce31e173f901e7ea0f6becdff5070f661b8b0a1de9c25"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.1/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "738595d8e79b87ebd04b3b57c375953529ff3d5aac1e7fad4edb4be44be1fd38"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.1/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "70ab8d89b1f82684d68762472409e26835d0495d6d72666faea887eb33cd5df9"
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
