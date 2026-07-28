class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.31.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.31.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d660d55dca3da4312740fc1e2b123407a7a8e817c2589713293f17acc6b4766a"
    sha256 cellar: :any_skip_relocation, tahoe: "52edf65dd619df2fcc6871e6a8abc2d58050464e73dd7fc75a5b48f2b2df1a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ad93a1553ed904fe82e378ccab538facc26245c9524b6f5938212ed186be9aa"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "c45d83c8df6b96f19d4e37f3fa9fe811906be3a53ec79ae44fe629294804d439"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "596d6ca83a0c69ef808890780f9fb4b74dc96618668ef89500087fadec2eaad1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "588e950404714a86d1f553bdeac7d18fc2084c46915bcc3938a16b41fd1467d1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.31.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "18fb6049ad3f550a812de8ee6e7b26c015c2980dd676a30364e6dae2c1ba6a6f"
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
