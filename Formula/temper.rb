class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.15.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.15.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "b4ccbcd40bea22a36f20143c7bc700a84d6c96a745e838d75a2a3f061bcfbd81"
    sha256 cellar: :any_skip_relocation, tahoe: "06b055f5eaafe5cda9ea1f24737204a9562f51cbbb6c0b62617945385eea6492"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "37b4336dd756f24d02dffcb14f2a27d47eeb306805a3b872f2fd5b836b75a5b0"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.15.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "b0b9d413ef3c3187a90f7705d5e5925c5435f089d2b23a5d0dafcd5026a165a2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.15.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "96bddf444b9c1d88c03400a47745501da2ae783eae7637572750a020b5485c30"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.15.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d0d4ed8f95d254a8546f113bbb7299ab83b1620fd31cbc29679a5b20cc85a281"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.15.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a2eea01bed3acdc0c548116e54e345a7630766fb74da111aaddd52058cce0a00"
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
