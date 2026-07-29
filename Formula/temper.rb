class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.33.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.33.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0750c266ff76a79d24f8576d35150ff7a65747de1f649b1027445123c3a29be8"
    sha256 cellar: :any_skip_relocation, tahoe: "8192d3688baa973c92f83f45964514830448cc31dae52c8a46f90067fd03137a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4706d3d700478b21a945624a9452ac2cb0dd0976a86f5b92bef517de741c5697"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.33.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "99dfa9befd45c1892ce3869ca81fb4481bcbb774bdd34b2fbd3c96335dd5c003"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.33.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8f0be9124e48e5d36240fbef34265409811635654a78707326284b901d78f657"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.33.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c5f4a26a10b89a1dbc5e19ed27b5cdf650038a488ca8320f603967e0ceffe95f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.33.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c427cf29aab39449eef1d5d665ce490355bd6961cf8778281bbd08a25e636c00"
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
