class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "80f0c93e9637f0118928d0fb24beb89f22499cbf8df0be3aa777365bd69f219b"
    sha256 cellar: :any_skip_relocation, tahoe: "6f5a8ea0c5f3f197c83faa1b5da9969361ec1eae349cc13f1995ed467db5e528"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10dbdeddde496e42a54cb0f74aa09b6f8eb6ed219f4109a8c84fb81784e110df"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "90788b1e5258b72560e31784103564780dfd88f0c1d2d4e0a47c9ebd60d01164"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "030247edee2a3e8b7d604655dfc1ff8e9c86015043760f05fb97f0284be6bff1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "09990076e5912b47ab4b83d167a3ed1c85340d5fb2754d03b8b2d8b58a597509"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2a2529eb4ee6dcd6631d5d111beb08e8e08f53229f95d65e96000eff795915ee"
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
