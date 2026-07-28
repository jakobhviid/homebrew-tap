class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0423aca305da3052e062660ac13f3897d4433f3b8c92a10c475645c029f7d0cb"
    sha256 cellar: :any_skip_relocation, tahoe: "1d2f3d02e9672dc7bddae22b6d9747ba2d53d3f4c94fa2ceb7e0c32c440d04a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d363b857f317745f3fe8cc4a06e1b6a79d6137cb75b548e3a50cb6dd0ec7bb6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "25840943c4528d116d7b4825f83cf9f287133ef294e2c7498eec130e8823fa2e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "e187f953e1219275a1dcebb834da5abdfb14ba70f424f6e2cc03e1b002f401eb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "de9b16d63d7ad003c81340962e637cb9bff185022f0354fba7a08fcb620e74e9"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "772cbf13e8fd6075a25928296d39dfa3d720d755fbee6dd73e917268ee6110bf"
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
