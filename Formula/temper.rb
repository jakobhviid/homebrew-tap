class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.8.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.8.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "bcce191ed49ffa098d44769da82e924530370297a25fd986502f1d1bdc768845"
    sha256 cellar: :any_skip_relocation, tahoe: "33f57697cf4fc78e96ccb7072c23f8561dd3fddab01b6ac17a67e9a845fd07f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bdc31553fb6ddd3da18589e454261964c5c57753d65ce6faa0bdcc457909a56f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "1d9d03211bd31ef36f16f2a05374930e24aaef53e14d3304c5cad9604b30435a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "aa2103d81056681c87a85d3de1e856fc4c31bba66b7715237d4ac0f75ef8d7b2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3946a19a0a9c20718c445f436058b7ca601aa9a03ebe159e3907096bb258e977"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.8.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1974541a907da23883e72b41f7b2d6172c0c6ee59208049de6c9aae6e33bc3d8"
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
