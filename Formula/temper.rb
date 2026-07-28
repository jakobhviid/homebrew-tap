class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.20.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.20.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "7a747823b8e76dd2df9c11dcda322eabfe74b575f1e9f53438b2c953e6231165"
    sha256 cellar: :any_skip_relocation, tahoe: "3aa62befacbe56c2869587a4c5ce3f90b0df880b08ab950e6cbe22defe22a503"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ce5152d47f142baca2ed13c7f1111be075ae1387dfb511512812a2228e91ac3a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "b6963be2d29d302342ccf28c8965a351390e1c68585d2f6c4f5001832788ce75"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ca60a08229d959fddbf25c37aec2b600be05e97ef7aa447ef283e010bd831946"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b6ab62c17b84730549b0f7519249ad71fb8e22b2c395ab2c85ca32eb50e36dbb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.20.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "302246ac5629920469edfad1ab217de5e1ecdd15c800f1fcb29ac33f9cef17f8"
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
