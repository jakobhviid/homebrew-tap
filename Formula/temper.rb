class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.31.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.31.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e0df700930a17de8ed27b7cb51c13afa5deed6571d7538078903d2338d1c7324"
    sha256 cellar: :any_skip_relocation, tahoe: "ccd399905c959d9a675effa495ae7b9c46dbf787a80a97ad4440fa5df48f3e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a8d47ac716f1918f15c800c0547698d54eb8275ebbc70d0d6f7cab0de2018e7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "31209df14a34448a6be0415960b668f56da2017c9add16faf568fd9a4112dece"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "7ce7a194525978c367852ac5082156c5d2557ea2e047667a58f4ce0e9b5c809a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b29e3807e58b56868bd2758f833617651414caf35f972cc3b34da26dd395ab0b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4c2b6601cb366ccfc3b37d7259a9f79c9095ccbf6c1d7638918ca3333a6f56e3"
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
