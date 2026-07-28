class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.27.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.27.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ea4ecb5e2c2748e608f219561fa970d5b8c209f6ac9183d8a7abd87f26c9a332"
    sha256 cellar: :any_skip_relocation, tahoe: "275c0fb9772f846940cf77cb0b9e41618a8a7d0c4b20ae3f892e13514b1a2668"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b431e4b8ca267a562b17d48e4de18a1f7787bf8c1eec5a8cca4e1270d8838657"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "95f01edc38acf5088f06e3607f85bb557971949412722a36254d079510dd0a5f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8161d67f9fbb3491ae2cad6bd46fd312436fa1a0edfbb6d5b4cd85fbc08ca940"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "81bde4fa5ebd7186fb347118aed34cdbd210bd12684583d7d55c3f2b7561de00"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f4fae0bc2590034b9a0cb45ab5612b23d710e484310c011bda514b684ee5c401"
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
