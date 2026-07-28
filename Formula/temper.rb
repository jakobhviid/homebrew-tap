class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.9"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1da140e8b30e5b881b73d7c086ac3b942545aebe430f8d898d51e04fc8351e3f"
    sha256 cellar: :any_skip_relocation, tahoe: "e0fb723781d91d49bda3f994d5d708df728916b9ce64b015a7d054a9463156cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e2a2aad6ae4265305442f6c484a6604ea5af606a93d765b4f1686b91d630d4d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.9/temper-x86_64-apple-darwin.tar.gz"
      sha256 "efe00afa2fa092779ddb4327963052d3edaafa0fa579753041d3e6a8a836d100"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.9/temper-aarch64-apple-darwin.tar.gz"
      sha256 "52df15bcc1e697e9d5ae8153f969e17fe0522ae0103f3d14f25d1d4e3aa0d3be"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.9/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e412086f3c76360a89a0e8892306fa4c153537e9d48e0c264a8b69fc39da4f17"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.9/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "06afb84641e62ef729407e9f43405ae151c0df1a04827b7ea2909dcd43965c6c"
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
