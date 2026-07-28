class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.23.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.23.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7760b016d8f350d2f806393923d4aea135acb1550b0096bb773f7bb8a663139f"
    sha256 cellar: :any_skip_relocation, tahoe: "c2d51ef151d91eec7fbc4d4f7d64395203ba7f621e3dc5d7e3fe6b18ff3a73f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "884d49f58b68f05bb5b4f00065b718295084743789878e26a241628386fe3a9a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.23.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "99838dc428c8d1ebd81e12674a8367ee4a1bd2dbf4cfb749483b7f2dd048dd79"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.23.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f45eafb309f6d5482a3c7dbe31fdd32edcedadbe5b3cb9ed049f52bd8f9dffc1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.23.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "47b3f2a45e0599f849bf46fb4cf6d92937b52e7ee3de97eb8493e5b7044cb143"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.23.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "224bc016674c6396053c27c33b855f93e018c5bca4b149aaeba2af1c320ddb4b"
    end
  end

  def install
    bin.install "temper"
    generate_completions_from_executable(bin/"temper", "completions")
    (man1/"temper.1").write Utils.safe_popen_read(bin/"temper", "--man")
  end

  test do
    assert_match "temper", shell_output("#{bin}/temper --help")
  end
end
