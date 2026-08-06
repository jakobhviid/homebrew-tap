class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.5.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.5.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e5781e2a94786830236127dda36b13da2b863fb9c7e1ee7992c6f9ed45690954"
    sha256 cellar: :any_skip_relocation, tahoe: "543f826723365a2e7392f09aab0ed136eb2b0ff19b9b62af613a77bba69a3f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc92f9a19cc3a70b04ab86488485194d8fbe65d1ad51cd8cc0dcaba3492baba4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.5/temper-x86_64-apple-darwin.tar.gz"
      sha256 "38da645d1d1a238e25b26f5d7e1dcb2ae6df827350a70e1e62e84b9b45b8ecc8"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.5/temper-aarch64-apple-darwin.tar.gz"
      sha256 "4c43fc1b38a88e5ec83522c0c20b3946ae6938ab60e2490ba07506ca76f54d26"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.5/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ca25009047852e89497a428956f1d75a9eea5a3edf48ef47ce114fec60c845d3"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.5/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a65776979213305a0101bc83bd2b8bfb39afd39a39488b8c2db15dbd71597a42"
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
