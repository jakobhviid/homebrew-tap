class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dfb9192bcdf1ea84186257188900b37dd45668d8f0f086b8af235fffa4c8c7fe"
    sha256 cellar: :any_skip_relocation, tahoe: "81869797bb8796e88d103db68af3a186b0a15f7130f83a02087f4449a5f754a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "479a410c1b26368557ff5db0abdb7c07fd515f0a2180c90740b1f325d9fdf82d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "25a01ddb4b600c9127ef55e1a598577a7d6c200a7283b4f2abf3cca9bca9bc48"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "24ba57611869a998d1afef58aeeb24a8c313e7e51ae581fc7f47f075c7152014"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3edbe931f2efd3a64f8cec2e2fac35a94ed656ee023201d8a945eb70e855a30c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.1.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "104e7351681e55163523250c55e0a0bb3201eda1f535c16c0588865c7b338595"
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
