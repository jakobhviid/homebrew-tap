class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.2.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.2.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "31e9ab5f6a43f2a48e207bee47136cc85147773dbf83db973effa70c13034e96"
    sha256 cellar: :any_skip_relocation, tahoe: "5b3cabf2046224f3f1c41fc0fe3397ebb00457a6043a3c17acad90549086e7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "722fe9e8e4da9cc92ed7b0a647b5c23ff4ae822f0f03e291510c59ce931bceca"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6f576aa010f2c6320eb3433109ae63e484c798a039e6c13aa3983efa6a9776f8"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "fabf55f51f25814783d5d7140969dfec68c82587e4100004e6709d0876c60bb9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "db11bdfed2433e0d798695b4e91683b92ee1687c05585dfcd7ce6362deea47db"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.2.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0e2a36e896c22aaaea5c3c123332d0744a5f9fe7fdcba99f2537f2a3cafdfeaf"
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
