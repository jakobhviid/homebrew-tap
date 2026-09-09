class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "7.5.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v7.5.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "98de29ad0149e8cb4909579f9e6824de6eecce6bdcccb99e67f7407a2841d061"
    sha256 cellar: :any_skip_relocation, tahoe: "71e46cc596f5c9b8483af255d89a269470afad72182fe9c8e48d1a3f816f37ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc5336600a17e27e3a176b0bcb4f08f160c0130cf272594adb744b554e232c17"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.6/temper-x86_64-apple-darwin.tar.gz"
      sha256 "ab03def9acddc3ebb09ef6f80a72b4f26c6ea153855f3a38db441cf99a896b71"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.6/temper-aarch64-apple-darwin.tar.gz"
      sha256 "2ccafe95f0bd969bf7f9cce50b9889b288b03c9cf6d1afd948d59a87844b33bd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.6/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c100f6201bea3398bf0fc973da761e2eb2694506e372758dfa0d617466afd59f"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v7.5.6/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "560d830e2f381c0c880e43528baf378d505859297b8ac4c21b153481edea5f19"
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
