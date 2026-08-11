class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0d436908dbd59f76cc042f4826cef689ebb62554e335ef09337b36936054e333"
    sha256 cellar: :any_skip_relocation, tahoe: "9616dc2f53cbd547a822747fa808a02867fe1de4534290462ae7b70d9afe7ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "50d70bc0b07c86cea4f2d3fb559c29f6e9b9a4b7b703805c4e03cf23db0de416"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "68fc7736eb4507a2ad447c82469d4b9703603904c231371b8b0c0745e57a0249"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "29ec6164342c45a7a4c51fdfd15c53de77419fc220d35482fc53055900936d97"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4fdd126462e81765e03be4c0549622731dbeae670867ab6c8cf409421a5b690c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e8b58fcb8cfd5a1517ebfc504380dbec646f8707ef7b7c115a571b629b8121bb"
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
