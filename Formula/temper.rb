class Temper < Formula
  desc "Converge a machine to a declared spec kept in a folder of human-readable files"
  homepage "https://github.com/jakobhviid/temper"
  version "1.24.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/temper/releases/download/v1.24.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4517e4fca1bb5eb6d6455d388bbe760c5fb35348ae7488bbd072688811364bb1"
    sha256 cellar: :any_skip_relocation, tahoe: "333a191cead76f7f5d4d4f08f67b8c4a78cec8007a68fe2ef407b26319a61aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eff8f69696d7c14087215c138be21250c4d88a36047a5165a334a7663c70774d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.1/temper-x86_64-apple-darwin.tar.gz"
      sha256 "be92330a73c90a03d6d01f222b6db0f574b42b9874ae49b92d6ad0ea6f4ab6f0"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.1/temper-aarch64-apple-darwin.tar.gz"
      sha256 "d1ee54d52c36b523e2549ff690c014937e15e91d1b9fa57e532e155142f7860f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.1/temper-x86_64-unknown-linux-musl.tar.gz"
      sha256 "10af59e545fe07a241de7f7fad7db5a8e7c41e5ca86ea4f666e9f9ea1edb58d4"
    end
    on_arm do
      url "https://github.com/jakobhviid/temper/releases/download/v1.24.1/temper-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d092d73c3571889e64795dc7efcaf17710a687767187e9ddfdd49e2509ef6963"
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
