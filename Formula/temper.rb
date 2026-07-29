class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.39.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.39.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2652c824a48f88f6d9b95a4cdc4fc31abe7b59acecfa2ffb85853566572873f2"
    sha256 cellar: :any_skip_relocation, tahoe: "1710de73cbb1d592f7c035359479f905e4a9270726f4abf01edb54b18a66287a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "829b9a831536f27cdb3af7b1d128a5f738e8ff4e18b3f3c41ca267cf19d1b6b8"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.39.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "52a1945ba7c8827905515256d4f393df57a375b6d85d7b963e83e755233bc3f2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.39.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "a27704fa6fa9d6b6ea2bb9d7906e5667614396d5ff55e4a783b7007756078233"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.39.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f4e8f78f3fb3d394983d10a7481ad6dc80387b86d632cf7d3305301b44a96ff1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.39.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "27c37d0457be62ad77161eaed2750cb1b4e6f992ea434b68a97a1955b5c37a16"
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
