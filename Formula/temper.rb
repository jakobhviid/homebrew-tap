class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.19.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.19.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "29d9f485057e97bbb12d5e8ab4655c6d3f509ea836a3ce0732ca67ccbaa822c2"
    sha256 cellar: :any_skip_relocation, tahoe: "37fefb225589213e065795530db9fdddbfad2a2366a19b095751a6bae1d444e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2d51d4f7099e28841ff87c4005cd6b265462d20d8b80481be0624b4fbb0d282"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.19.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "12c9a3dbf83c854473ed3ad4ddd926bdcf471a74fcb51f243227305f03e867cd"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.19.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "9e31edb3d0c778f1b43934a758128fdc386b6c9275e0a255a2ce72055801fb22"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.19.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "08611226ff6f542bdca94a07b581bf39a3ffd980651891d35821a8de945ad66e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.19.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "08a7ac55e2c45da443a7e932ab93044a4243fcdcfa2033e2ff6eddbef0cda218"
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
