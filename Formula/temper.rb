class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.9"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1cd51ce3d17dd5dbbf7b013829b4587db7b363151d9d6686d872c0944d86af71"
    sha256 cellar: :any_skip_relocation, tahoe: "d8f06528256f9b2d0de3d3457120eaa8d702ec5ff0f302396bf9a53dafbe76f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ac62d10fbf69a816a2c678dfbf446f6a0e4a6a5573589af01d4ac47984c96fe"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.9/temper-x86_64-apple-darwin.tar.gz"
      sha256 "9633551cc2eb68f02a833b5250eb21cf7522dbd797563476f24f350487dc2f27"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.9/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1df2903a954b7b3b0eef4b9dd61d576b914c0d55c3c80a6f92a6a647810df981"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.9/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0631a8fb329e3dbcb1a52bfbc07f8f1cca83b30d2ef08a0424875c71503aee4c"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.9/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c187b17236101664217508f41d9f900ceb3f28a9980e9b183474b8592bcb1812"
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
