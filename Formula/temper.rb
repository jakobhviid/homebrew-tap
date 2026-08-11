class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "6.5.9"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v6.5.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "620c17d98b594e9106f2b3bb24156d99d262590e2a16643f1bbedaa40dc72b51"
    sha256 cellar: :any_skip_relocation, tahoe: "31aef39eb1b227050ac587c4e87b12d35e44c1a26ce793209109f5e74b6fd7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8209545809a049a9b633610a00c6dec4d1b185157287b670c2dea44c9f20e496"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.9/temper-x86_64-apple-darwin.tar.gz"
      sha256 "b360e5c207566468b732fe1402975d14d1860d01129a171da96d6cf4557e8bc4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.9/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d5da5f9e2e4e2bbb16060eff5f7128afb254ffb8b7fbe18082b261f2204e696d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.9/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0820b6a5a08d9d93dd695ef9af51cb47009c15f5276fd9f09a649160c0607411"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v6.5.9/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1cdd93c66482ac0feb4e360f8aacdad426076d1bebe267bae675d02e18c6ef1f"
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
