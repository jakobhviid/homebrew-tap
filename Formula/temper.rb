class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.25.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.25.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "988061335ac8310623b63baaf42d14c5522db6c915f06f64476ac62375da8b2d"
    sha256 cellar: :any_skip_relocation, tahoe: "ad88f5c8f7a7284bf2fe8ad47e7cdfb3765cbcca48a62c285cca0e326039ea49"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a6108a2e797799b667a25f703d28c3fd5a466b23701f362da5d53d6dc77882d7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "bf421d47ba22bee0ef8fdadaf87e35492f6fd70305d28e1eca08ed73cf8bb385"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d6bd98e4483e10631aa84bf023dff4565e519f786852b0678c83f07bbf5b249d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3a84c05782d49b3dce837672c15c630082569da7a2e91360561e9fffd57ca78f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.25.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "046feffa4705e42dcc4d419526ef3b3322c58e215db9225049fb21cd64f83eee"
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
