class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.4.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.4.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6c53f1f69936f8a7c04b141e82cf1d9a81c07c22210aa75daf9df90c12bf7a74"
    sha256 cellar: :any_skip_relocation, tahoe: "982c7991e2b92f1560145e4aee8b388bf31874b7e1bf3b6abfbbc3ac9ab92ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e38f9018e7ed61d6fa4a8c8205bd5e47e3e9f7d9ef4b2cd4c59fda3143d39a3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.3/temper-x86_64-apple-darwin.tar.gz"
      sha256 "d185367a80f4253200dd62a9c84c85848b8e83ce1f9fde703b1d35c128df0aef"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.3/temper-aarch64-apple-darwin.tar.gz"
      sha256 "f9cbdc3612ef3cfe245ec8583c60c61a207966bdffe860881f6d3719e071142c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.3/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e97b4aa61327e1c745783f999cb848f38b2ffec1b310ff5a20a2e23552ca042f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.4.3/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2883f00bd488af5df72a20088257d8fb54430e740a9342265fea3795a6f02dd6"
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
