class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.16.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.16.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c9e9cf110a5d8e0e7839099b460535cf6c15c6b66d95f275634a9e4c9a7227c6"
    sha256 cellar: :any_skip_relocation, tahoe: "b503a3e38ae71f658a154db32bd865784ba8f36a3214fd7f4e21109159b45952"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "757bb2a834f1fe4f2668d70d6e8efa4988160ba4abed0b3f9388ac05635c6bc7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.16.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "8408f3f5f46609eb961161643605095d28fdeae2080bb5b6883fd9ac3a6ab0cf"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.16.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "1a2a788494501d293bf68d029ec016718ccbd1403a6df3fee4ab2cf1e5fcd023"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.16.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d74902b56a3635670861b2aa4922f72f3faa53662ddcc6b57206a498213196a3"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.16.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e8dcaf936c1d4bfd2f9428c4b795eb401f493df7babb5b8b6c62456f58f98396"
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
