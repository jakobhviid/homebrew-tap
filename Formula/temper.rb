class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "3.2.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v3.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2b4d946008688ac8d613fb49f846fb58b8618c2fab8d88213ab4777ce770b9e3"
    sha256 cellar: :any_skip_relocation, tahoe: "7ae067e040636ded060b94864430a9fcaf136ae7a0a2fd1067084b349f256269"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9e801dda73588894a468110d22d8b27f5d347cdd522f6a70b33ec9a6149ea58"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "962b822831e775f1eef5b8ace2b1c6043f81b79aede6c131f6d0d1e7b39092eb"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "38fddb1b1893dd204c922140079dabb9d541b51a5c6c97ff4c67616dbc2dc7b7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8e546b8abd59530743b6dd3b6c1e7f5fdd2a4d76bd7255f3163e4941ff37a61e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v3.2.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ccd02fc8a67f21d370fc4bea08969070b0348d21d593ed990640b22b2e83088e"
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
