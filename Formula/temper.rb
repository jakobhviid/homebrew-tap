class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1e84196b5de230b5e189ba304535fb097f1a14a2a4ce4b6379da8789ac4aa07c"
    sha256 cellar: :any_skip_relocation, tahoe: "e6ba4ad5f571b1b68d39e3b98bdf593fe22f000a2214835d0f3789f85f0361b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34fe38870f00a1292b66fa52705d8d3ac8df149e8771160b3684852a731fcc99"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "5092aac257f1aa6f3149fdb3b9f9c7132e0583ee8a689abbce972f9695ec552d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8a447cd34c4a9e458cbd42201a008181036bb391e9a6e9aa22739c0fb4ff6d16"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "72094046c8be6326158a6d876fed2dfe2adc694564a59281dcd874cb5241539f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "54d761c99c76818bd90da586bd26e5fc702a47bf5dc83742446b001c2b54c44e"
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
