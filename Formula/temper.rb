class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.30.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.30.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f23199ce999ce2da93ded39931ef9c791051d648530b5ab7ba104ccebe828eef"
    sha256 cellar: :any_skip_relocation, tahoe: "7ac2775aaccafe270611508d1ee0e1aefa869415b0c8babc6c557f933d9fef3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "201afb197b8a8fbaa57ade60260f939774125184dbcee366f36ebea1a2bdb227"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.30.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "81e36c57454f3943c214110ca3f8993416a86043956e646a8364b37213894d44"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.30.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8f76097ac0928e692e0ac77e2de7bf16f8d8d34cc14c11299b9f2d9bd26cd4c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.30.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4cf8df2a5d61c030cc36da4f0661c0f744f17341d370befb8a9b41ffda1b8b5d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.30.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e07384471329dcd0d4dccc255bcf255749c44b81d086d32503310a74b0da1aa7"
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
