class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.10.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c06b4649c17896042062a5bd94ff41dbaedad980090b993737765eeb7ec6cef8"
    sha256 cellar: :any_skip_relocation, tahoe: "0d8aa7120db4ce3285926529628e4bce96f2e9000939579a7ffc71456c59e2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a65a742836554c7bc35d0038e66bc16de67763ca756faae3a7d9849019cbd4c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.4/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "2f5205085182f937db3cd0dbc79d7c4fde752667727c4a26c0d18c809a57830b"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.4/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "3af854ef5d7ae661acb2390895329a97229bceb0fa601f088f1a91b7e38903b4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.4/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d4e2568359b6ef00962492fd5a40851352e98f93e2b7874f41b87f3144c4cf27"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.10.4/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9405fabe650c7701d69c07167b89584bd3f9298f32572f2b620a03bb3fdcc822"
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
