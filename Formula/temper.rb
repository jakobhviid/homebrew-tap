class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.0.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "661706b052ec27387c4f03606abc4ab3f8b37a76a08a02dc08209076830aa47f"
    sha256 cellar: :any_skip_relocation, tahoe: "e92e6737a515e969284850eb33426c91c736212b97158a523f9048f2a4281267"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "897ac979c7bf9e9cfc036694c53b0342e7b11b5fc96c0919820fa431c3798c19"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1d27fb8efe31d231578e4d7748e5034e1eec0b04a00c54b8bce970833900adc2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "c3dc7d7474c2c85c15e66fda755950aef6d85ec15ce0e55ad62c36c17b60bfd1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67b42dfd4838eba367efb33559a3ff67e2fac673797c2f19acc6b9b2a4eb6f5f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf02754f93137b2765c83964b724df49edd29799dfbed8424aa6da54749cbe86"
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
