class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "77e34083ce7b71b2c6355c4cca981904c57000bc90a5a0fea5f93087352b8349"
    sha256 cellar: :any_skip_relocation, tahoe: "bee025f58220c8a0686e7b67ab5d2c2e3f0ef126b00f91e2ec2d66c947a8481d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca87a459eac154baaf5dec35c67ccbcd6c1a11305dc30a9a8e4070c75067bd3f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.1.0/temper-x86_64-apple-darwin.tar.gz"
      sha256 "27f5a7f9130868f20bcf1eb2a742aeb838144cd3749e4237a68b4678fa65dab4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.1.0/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d093e2295e9279dafb0bb479d22a196a1dc0552baf7b54a37874a84f33bcd940"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.1.0/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f8ef6d5a4ad81900c2e429f859e3197ea932a714c3a13f6c3f46a78f8bacad70"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.1.0/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dadc020cc137f83b991958388b7a26744f0b798e303327eb88a4a1453bab0c6c"
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
