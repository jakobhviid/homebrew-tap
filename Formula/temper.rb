class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.8"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a925f3fa30992af05067d7393a3410f81225fabefa7cda77cdf28166fd14099c"
    sha256 cellar: :any_skip_relocation, tahoe: "c4183f983bf3a0e2f6173fa71b84155b0c0df8be7a180ee8e2fba5312366d7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c8994b8179a803436e6a3613cb09ee41cb19e33777bd462befdcaebc724a12a5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.8/temper-x86_64-apple-darwin.tar.gz"
      sha256 "32b4ed89585594197438f44a12d1c8a02254caabdd689fc5b635bac9b2dc4be7"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.8/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f06642efd56c039c2eb69182b7df70159fb5250810b4a682a7fb02554dbe9d5c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.8/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "942b50c41bc4d746534e4b4f840060b18786717cf5bb94919d4697ccc3f7489d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.8/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c44a6e53dd8d94d01181046054f12b58030934622ab86bb113cd14694eaf5093"
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
