class Dotsync < Formula
  desc "Sync user-level config between machines through a cloud folder, using symlinks"
  homepage "https://github.com/jakobhviid/dotsync"
  version "1.7.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/dotsync/releases/download/v1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "26be99d657894c0723e888dedb26f19846dcfa2fbcc9be7d5d5ddfdc1c5a84da"
    sha256 cellar: :any_skip_relocation, tahoe: "834309ba56bb943f9279d02cfe743431fe13c67680dbdae39b9ca05d9f2be7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "295e3377e2b74db60ae5b75218c297ab1f1665a35fd233a55ffdbd36bcdc6345"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.7.0/dotsync-x86_64-apple-darwin.tar.gz"
      sha256 "d4499e01a6f6e08a39d093657898e8189d0cad43e8aede0d58f0d81f15f4d903"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.7.0/dotsync-aarch64-apple-darwin.tar.gz"
      sha256 "203072a78d549afc63bf62ee6c1691c4c372df596b0b98633a55379508c2068f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.7.0/dotsync-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4d805e91f598df4623f741ebce60202618d8a6221d1c4b656b5c963b8db7a604"
    end
    on_arm do
      url "https://github.com/jakobhviid/dotsync/releases/download/v1.7.0/dotsync-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5582ab95c6a847d1810849107ac4578713d1a7e4bba8feef1b984ab3923687e0"
    end
  end

  def install
    bin.install "dotsync"
    generate_completions_from_executable(bin/"dotsync", "completions")
    (man1/"dotsync.1").write Utils.safe_popen_read(bin/"dotsync", "man")
  end

  test do
    assert_match "dotsync", shell_output("#{bin}/dotsync --help")
  end
end
