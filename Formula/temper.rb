class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.3.33"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.3.33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2fb433b46dcad679234e0c36ed618a991ea925c58b5882ee31ba33b91e818660"
    sha256 cellar: :any_skip_relocation, tahoe: "1e40913eaf97ee55978008c2c4416516f46a402f141e497b2650b5ed543c9087"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac026447bd369392ed9050b6c8133c8463a394ad3d45756d8b128595d781c7f1"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.33/temper-x86_64-apple-darwin.tar.gz"
      sha256 "a6ed406e9c267336c29b97cd881a85aa552b51b994492a625ddafb9b1f276d84"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.33/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d04a66aadd7671f302fe3eacad75d469c765bb2e61a90bd99e4f1857b0239583"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.33/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f66fe717ecbe3a987b1d12f933100b71c4f420172df04f30369a9ec3c7af76ad"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.33/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef7a9c3689adbefc4353593ddec7fcb77d0e73992178b20054ef20f449f121b8"
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
