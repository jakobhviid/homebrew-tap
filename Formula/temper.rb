class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.8.7"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.8.7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "fe6962353c7b08580c798affd60995fd057fdbd4779b42d0dcffb65b6de2699f"
    sha256 cellar: :any_skip_relocation, tahoe: "f093145c2a00b91a94081315aa8f92f412f8ac29a9a8655bb7736d481035ebcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b38499d12b1a7ae1d322957e035571fee729c91f38ecea8c544e2980a2bcbd0f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.7/temper-x86_64-apple-darwin.tar.gz"
      sha256 "21065d172a09b5df68730e52a2c1226b0f8c41d8027f2be64c6f9ee3d701f212"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.7/temper-aarch64-apple-darwin.tar.gz"
      sha256 "8036ef9617447e529f578cfa956cabd1746eed39938bd6128b0966b2e723abe3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.7/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7197d20b55a8ed2240b0ee4ac92c6d3e01067048d781f22151ea4d1a60053f1d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.8.7/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9b457f76d0eb1e9151484fd46af39a841e4d03dd586545ab40cd981d30190b52"
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
