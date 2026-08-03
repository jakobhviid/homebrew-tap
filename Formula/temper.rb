class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.0.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.0.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0f447bf736ba04ae1f4079838f88ff683fa912151a8bd79dd4334f62105556fe"
    sha256 cellar: :any_skip_relocation, tahoe: "f4d3f1560a9c3f69ed5b3295fcb46b690fb6001ce9994c1eb6869df4586fb4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dacb91605f34c6962c9f277913336ff99a74aa9bcb09dc4e313c738f5c37764d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "cb3f18059eb9cb6ab290296b1a73e3c29ff695af1e838d72b868e67c3d6aed3e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "b3f1a6e132b229f1d9c763ba09a7ce867e78f8b5c0e2a5112762c24075185e0e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fae6bcccc1b0d42bc080fa1056f0416b6eb330a37089d0222e3850eb0727f6e2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.0.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "98137989839a7f73de4b70fe3877b62ae2a705b28f7b429deb90f0f271e39616"
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
