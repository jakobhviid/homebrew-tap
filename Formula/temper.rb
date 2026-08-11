class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6475bfc1dd84f7cbab7aa71dd687b8c22ab2de3ccd96b0619909cf8eb38aed77"
    sha256 cellar: :any_skip_relocation, tahoe: "4da0cdc6226509b701261d693a9829333d7db5b8fab39592a291f34666a8eef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "87630cb6abbccfd8edb69f765ff7947b6b7401c6a53b7202bb4f978d41a28fb5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c98608f86df744e5db62ca2d243d054ea01a4f1282a1d348526c682657719c3a"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "802618b8d75700a6dbc0b6c13eed190ea01d640b703ff0577e6fae502589a26c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1eeacaef6b1b750473dd4ed3b8cb4a2d1aa521262b566c63dc6bc4fa701578f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9eef8ce925d5662e3722f6b4f54d5976a6ac926fd4dfca47117695a0756646ea"
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
