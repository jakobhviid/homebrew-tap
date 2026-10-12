class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.11"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c21852ad9650d4420781025ec3c0e6af00e9c5258229caf2632fca405fd65579"
    sha256 cellar: :any_skip_relocation, tahoe: "8fbdc4e6bf891d1a598c1d617842e924452f4e59e884b5484125a0887c538933"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0569d238d54527e5cf377b22773d7f7da471f8364a9092d03c702e91888f6871"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.11/temper-x86_64-apple-darwin.tar.gz"
      sha256 "2e0000472ccf550d5ae9f0e6e8eaa22f59fc8858b827c09ee6d8801eb0664f35"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.11/temper-aarch64-apple-darwin.tar.gz"
      sha256 "76eac75acccfec49758c6931e50e9ba5611370e5d7049ad6b1c42c025673a098"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.11/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9745e0b44d3f5a994fdd4f3a7df82c3dffd0d81f2848b3dfd61755de15caf514"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.11/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "09943baacfc26b42eabd1cc6d44619c1ebf262b48021e4ecd29f78f58b355a67"
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
