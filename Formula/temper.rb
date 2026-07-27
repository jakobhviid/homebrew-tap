class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.11.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.11.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a62ea2d656cafbe5067a58cb97d189b4ee77b2d6684eef2d8ca06267d973c907"
    sha256 cellar: :any_skip_relocation, tahoe: "85276746424071cd540cce82f647a97d9232f43a2896428133f7e1e5c17c0953"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a660093b609bc5a93d014bc313ac949d79dde17589135edda0eae3213484c773"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "0e7bd0bc4c04446c1afed66b0f2ce963466d9d890776a25cdaeff9bc839f1619"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1e9fdbe5eaf77568be61ea39b738c75e05a7265dcfdee7510ea0dd3b1f27d6c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "16999b86d9c7f23a97d7e0a38d9a614aee01d9e2ff2017549a18d63b70dbd65e"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.11.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "372729200e780a4c48f025dd9a0e2195c9d361214690fd7edbb69ee159dffddf"
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
