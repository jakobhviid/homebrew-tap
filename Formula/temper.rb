class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.3.31"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.3.31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f209a3c04b0c15ff00164f47b81b4dcd55f8dc53122376ba06453c86b6259a8e"
    sha256 cellar: :any_skip_relocation, tahoe: "4120200f3da1eaa8d544ed928c86918bc16baa87864b00bdb659ffb83666faa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90c49f4a3d97c3ecd8a4d9362e5f7117a9aa181c878326f6662a64a8a9488b38"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.31/temper-x86_64-apple-darwin.tar.gz"
      sha256 "60c05b0a578ac8efa9ed38d07a7e65678c37d3cafa8b31967db7056a53669e97"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.31/temper-aarch64-apple-darwin.tar.gz"
      sha256 "efae68f1c9637cc0e70e7c37c2979adb3c3a16f215e82837e891b1eed868a228"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.31/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cbf68fcaee23f8ef96e4cb5d86c9e7d57ed1429d7ae97946d0795af987b4aa1e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.3.31/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec6982fdfe12660a013b6ec10938f80da5d1aa82ac69550035c11a1fdaf35bdf"
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
