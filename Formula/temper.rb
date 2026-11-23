class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.10.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cd4dc82a698c776e5d8b02bb3db224a4d13a0037661c248dee85d21f634e0d1b"
    sha256 cellar: :any_skip_relocation, tahoe: "0d8daa160c08ddcaef160835b4d859585900cc960df2cd5cd629ba7c256b9249"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3eb65cb6067ddcd968d0362399b7f599b5b8baa24f46c2a38b6cd0cf05145d3c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.10.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "39e566da50f97598f87a25f2c1096b881ae69e2ed381e1d37a31fb3797717bff"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.10.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "621d34c19ebb0b69ab3d81274570f06c341e11f68777b683503cfaee15a1b70a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.10.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4501b161577304a8c45f84bf6a07383c1c37318720f73411b906c755fd3f13c0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.10.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ae7eabeb38f2e95f442c4265c8df5e3c97e299fe5a170a868a7904fcc6c3b78e"
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
