class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.27.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.27.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9537f02c6a5f4421bd7105098671b6fe77906dd19c873f4fcdb6b2763f0b9f6a"
    sha256 cellar: :any_skip_relocation, tahoe: "df009e5bb874c31382536e202235a5faa86074161b32821df4baa304c8f0504b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "128ce0c7c03e7a2f1b01c707692ecfc00b4c3efa91e2455a1a01bdc7c4a9d240"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.2/temper-x86_64-apple-darwin.tar.gz"
      sha256 "21785c0fe40171c26d273bb481ef95f76950c7804ce3a3c57feabc1a174ff393"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.2/temper-aarch64-apple-darwin.tar.gz"
      sha256 "4ace69e7ec8c9d0b714ccb635ee5103ef6131215a9b12769da2eece5886abe98"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.2/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "685343dba233b904f3ab23ca0a46ea839e55b5cc745647cfd3cb5fa94425e55d"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.27.2/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ca1e8d90cacb1ec716f0b5728d181a8a09d996058f4ccc78a042c70808263567"
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
