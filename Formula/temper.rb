class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8ee8b43d203a1ff39e9e068726553ef3fd236707fb7e97b43a6cd4929ab8e7ce"
    sha256 cellar: :any_skip_relocation, tahoe: "e3f93509feb14dd1b1acc4c9d52d674696775e223f73bf6ab03fe0731a2b03c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "81bfb666b5f819b899f3cca52ad8649774c990eb9a999410f7e669b0d5685687"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "3d9efa43ad78786505dc638ef285589ce69360d5193ae65c8689eb9ce548c351"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8c558bb4c07765a6561a72e94790e100a70288eb5dcad723c178b45532489496"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dad8ba8e119f89f015d02ca0b6ef19dcdf13af8792803212849ed5b3be6e6ef1"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "597a6fafbdc31360277e53e38dc4f926081aa0c5bee75827a2ab5c1bcb2d3564"
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
