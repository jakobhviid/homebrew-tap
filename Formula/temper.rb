class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.2.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c9a507bd34f53de1eca1660f6822a1b453871f58e65731488d207d43aed3cf7d"
    sha256 cellar: :any_skip_relocation, tahoe: "f83ca68dfec15f68631fd92075847d5f8d3d1e4f5fe407057bd346b19eee9193"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a96536e2cbcd3e4d0cd2d036a17602310805c84629017c2b2d1dc6e55e0092b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ae8d513b83da04670060936f1ec3ab6abfbafb5c7bb7112f3af04787872c681e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "25327389d998c3224bfffa74dac72f8f8f2a1a6f7f184298604937ebcea90547"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1b0b4075cb607027c6dea445249204387c8a6d9dbeaacda18b324fc473cecd76"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "399afc16dd7d52b1613c7408694ad93d9815ffd179867598d11d63aabe486495"
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
