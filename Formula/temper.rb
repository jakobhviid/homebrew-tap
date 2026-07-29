class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.38.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.38.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "406e6018c3e8a904c63d04589cb9d0e68249160e58f90394d4948b4da0bb516b"
    sha256 cellar: :any_skip_relocation, tahoe: "b4be7c131e26fd96b01223b003378f2ecdd3fd0bca1ce66df72364415bd4f32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "570b59b1440682b7b065f97bdaff850cf116c61cdafcc650ca69d90e0f92f7c1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "11741a67534e0c767f92a45bfdd38c67127ccc92be0ee1b60c4a8cbdc33e9bfd"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1068f358ab9c7654228c9830377228057b42f7a2cdd010ef078a2a8b59d0b8b6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f3091dc747e08038c6823e7ced4aa347c24fcd74d6954bb8f58200a69945a449"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.38.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "69e538afc73d367a90e8fb8fbc31166b0d2d6c665ef7f535922a4c603d854cfe"
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
