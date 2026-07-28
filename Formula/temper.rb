class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.28.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.28.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "adc1701107d96a6722ad86e95b5c665b4ea352e7ffd83069bfebb6dcac56c387"
    sha256 cellar: :any_skip_relocation, tahoe: "ec9ef375d4cc6ade112f13a9489d52978763798fcd47b4e9af49bc3e8e1fd1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d586dace986ad0883e5dcf65d97f47538d708a324475f0ff72540e8eb3034177"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.28.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6fe11f9ee104a967b6cafae23507e3b749c16c73567e6620394198875a1a1128"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.28.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "956e0f83c3b2a1331d8622bf6b7e52b2e496825568c76047c5d7321daea1f1a1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.28.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b2b0216bdf4e4eb4ac9619349aa959e5aa4a7fc6bc6e948340a7d07bcc63c690"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.28.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0e51da2cfa75ea30610092bf426de32d6bc46fe08da996cae419e31e0611df0d"
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
