class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1661a9cef4f81fc8196123ad900e0dfa32fb9ffb86d65c131dc0be50b5e06826"
    sha256 cellar: :any_skip_relocation, tahoe: "bdefb68d60556916fcbae1ef29788c16ce0ad7d4884e73d13b1b809a51abbc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7b6a2891c6aecfefa6cabdedb0b2851b16d44552e21cc6a0bb1d576677e35ca"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "34acb569bbc18d7c1e1d95edbf46d9a6b36b8e6aa8aa67fa34fec04c7488e51d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "bdfdcd540a549a13269bfe37c6f235e97b657be9e6fd96cbf6624cc70cf25123"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "253b13619e2c0622e05e15150e67dcd97995517521e13e735653b164ddb0c4cc"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a67648f7d5c42e22d8ffb25f9a844c9777d92fa8f4e797567919b5e3ce9fb683"
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
