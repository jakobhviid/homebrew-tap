class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.29.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.29.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "74f81f6dc1d128b602a85ac8d0d5e4ea3c3c949ca422cdd22533310d54f14407"
    sha256 cellar: :any_skip_relocation, tahoe: "afc464ee53193f1be867cf098502812078e08df05252098f276ee43014a58e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fcdd30b4ad9f025d228c2a0382780e1f3329adb16180ec331f5a90c1d29b172f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "6173247fe6fd6b7e3b046b384909331aa93e9e420abd9591c3797c3d19a0bfe0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "ab8e67d54cd212aff5a69029330d33af86ad16dd93a5b5514e9778d7ce217674"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f5dc74ed782d97f65eda026bc13237486e3b2ba6984ff29eb36a518a75df8947"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.29.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c5a785f42ed711d183b0d313c431212615c83c78c582f2e4472f6c0ef7047cb7"
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
