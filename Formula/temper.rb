class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.12.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.12.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "780c44f827cece1d90d652d99fecddf0bb990f43f58a92b4817f226509e99f28"
    sha256 cellar: :any_skip_relocation, tahoe: "ac0500f9fff6a7bdcd3864bdf4e4fde442013f81ce6d72c25a2557508d5d7d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "363e3b584553b742fb6e5d33b22734e5ae2261f8ba43f9554b70381721bbcb98"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "59f871e02fb0a67932e23185f3045c7bf93f4c6ebf5857a6fc467e6e433bbb54"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "7b9eead5b97fecb2d639c9693e0d7b811df82825246a414282fa89c203fb3d7e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "850bc1f35d0413330804be665f4d1998cc39d5f81b0c004d77a13746c503d06d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.12.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "92e6629d6d59880e3b515516f49b0efb35ad73b4079f35b4ce5be27aea043859"
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
