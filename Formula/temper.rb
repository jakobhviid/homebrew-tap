class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2f72c8c268d185b640a74881223727f3b1ff351160ca40f6bcfabdb7a66708f6"
    sha256 cellar: :any_skip_relocation, tahoe: "3f581c70cf9cceca9eafe400702e0bb0d425e8df6be889d553fb6ef364444144"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5cedb268a104bab878db7de9827a373f9237cce2563ac7486ba2c16d44bf9575"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "0f060f13286a4b74a8bff32e8839c8a74908622feee6d0ecef921012264f93bd"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d81f7195c15dbf7974c837bd709844aae1cfb021202e7692aa7fd90d0c40fdc3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f93ba09c73323ad48da66470166e185688b1910f993fa6eb1a3b9958c128216b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aa9dff3a74a9044df46b5d6222749e3286caec95a9fbca66c2d2ab3a1c3b60fe"
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
