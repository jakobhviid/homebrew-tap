class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "fb0ca956ef3927751b84c31f5888f36715b16685014a6b3934884fa2ef4c064c"
    sha256 cellar: :any_skip_relocation, tahoe: "9694c4a058042867dc7966336807daa63ca8a1582b9e0e130d63f1d1b4ab7ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3823bd52b02dab75fc804eb4830025390e1814e44cab42b595eb34092f4af4e3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "68a5cc6b10828e1748e6c01c233a02f84238aea8f1e2f0defc4ec83907f499f2"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "6224e1a5ff524a4520f5457f67121669c5c2637fe7d68d47d95ebeeea12cc4a2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f42d789a32b4fd0bc5ed0a4370423da6142f860f2a5b966737afd7c6d3bf49bf"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "47684a1352e6af64a3ee5d99d316c3ea6165d90bfbaa4d60d49ccba8a0721896"
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
