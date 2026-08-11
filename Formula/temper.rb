class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "472d4d995e28007c9e7cb0cf99f172158ae90c7945529a71b8cc494d787f1e86"
    sha256 cellar: :any_skip_relocation, tahoe: "bba053ab000703b582066e1f9c98347b63f9f90bf814fb750bb2abfb30ef8905"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94268e7a118394260bca2e6bde0a06e0d090a4837236319530b1e4893ca326cf"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "94104392bd2a9d8bc12fd4cdba2ae321e6023572a12e9a676f7e89c4d158176f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "e16e39f461d84793ac4b9893c963474f872e1aebf29ae8936307d42ec9e37bb8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c96c845d9cc350cc53dc121ff5523b663ba073146a3e3605824b08533a70e894"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f1fe9b5394bf29a4f1f22701897634b51629cd543faa757ecff365bc1b73527c"
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
