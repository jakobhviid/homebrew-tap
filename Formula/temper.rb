class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "2.5.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v2.5.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "013bca7dc556e84215532ca6db7d4a0e6f8b7862a987f03ec8c62688718ac5b5"
    sha256 cellar: :any_skip_relocation, tahoe: "13e960218884189a12eef581858cd4834ad0d6c49fc5ca9fbc30c46cc6d7e5e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "09f4436e38dcfb2ddd014f94bc57478b7e5dcb05adca22c0dc97a8e60aea094a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.4/temper-x86_64-apple-darwin.tar.gz"
      sha256 "50e1df7ffe23fbf90b90e2e09d02469524665aa3c25374f8a039e07d3e626e35"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.4/temper-aarch64-apple-darwin.tar.gz"
      sha256 "22b1fe0db96f2f78a5f216a28d608a5ee6fed8550848658443696b6b736bd748"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.4/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "729af36e80d7c0dae44a1d4f7f6dd27924ff6063ed97d0e9af5a8b109d6dbb58"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v2.5.4/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2e551684d145fc9b768b47452f6ba32f75d35c4a29a48c468b5cdbf36f1dea85"
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
