class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.29.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.29.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "09dab498f8b4a92de931fda8052356245420e8238f6603257e16fb392b426825"
    sha256 cellar: :any_skip_relocation, tahoe: "421540a61c06ddd45307d77fff673878a841f41796eef63314575308a49e14cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5fc89911b11271c8b6684da5c55da744ba212c1bd716644588f6bc93b11f403e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "e894c63247cb7306453150cf8291faa86684da20a9eff328091cf5fdc6ddd2d2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f8e3d7132d05378f9b93a0880a035fb0637519a837f726676bdec631d4f85392"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a73840c4f72c3502a5d3c644da0949caa35ae4c8ee1ea97443446b5d942b0e7e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a315968ddab800e8cb606bd75492dfd5646d9ff96c74d0d7166b822357e98a2a"
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
