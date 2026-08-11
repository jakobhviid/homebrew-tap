class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.1.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.1.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "eb14d110cd6f6491e59ff8adaf3fda0d02b4743c85c17699f8e7acf9d5218773"
    sha256 cellar: :any_skip_relocation, tahoe: "01a00921934d3ea97390ccd2578dc3679d1fcfe2fc80fd70c084eb4851e07a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4374168178b7f1c156b45ba7a23202839b288888c7033b8848e1fead3818eb92"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "a3faf017c16d86f4086d4168723f978d02a8ce8d0027c9b139c2ad6f63b0c743"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "829d09f7faa535dfc318b283fc34f274083bc2f7c87f2a320b216221fafe600a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1071711587455d514fd769fe3898b21b11b50b14ed9da19fc3bd40544971c76b"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.1.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ded0bfe88aa9461c30e446c26fa8afcad8e6360986ee0bd820649afbbef0f6d3"
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
