class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.8"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0dff0e1b4f215fbbabb36847fcb36b2fdb956686c743caf68c32ed10b43c72c3"
    sha256 cellar: :any_skip_relocation, tahoe: "dab08976a093b7fbdb51b3cbccc771daf047f53c1147c4b87393162da44d9f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bc5b08cb29904ae54863e76221bf8d88efd6ee77047d3e7207cc8e26b532c4b1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.8/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1215e6af3b69b9f041e2f3ba65dd6b29372f3526ed4889b54da6f2c984ca3909"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.8/temper-aarch64-apple-darwin.tar.gz"
      sha256 "7d2522272604e73d738d8148aab737bcfa26a50e4db4e9a7450f2bca9413b92b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.8/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ba6285d803ed9e1fabb8d83a3e766d8b786bcc1503a7166b6172f4a869f6317b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.8/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fa74b2acd1b413f6857a41bc6482fc36a8bdbbc1f80e14121429c4f39b37540f"
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
