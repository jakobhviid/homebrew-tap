class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.2.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "85f169ad7cb5b62ed5c945e6f2c6f3f38106ffd4cd7c4bc541ffc7f0a8dcead9"
    sha256 cellar: :any_skip_relocation, tahoe: "389ca3e9b96bd837a8d6919b4ccf97886c47529057d174144cd26bd038043c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffdc5e9903f03981b52308a68e53a0f1fc825077d94c2e000a80d0e339ff5744"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "9d7f53382df0b84f6d8342501aa6567bb156b0bb7b42818f209b6f69ff53fca0"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "39177ab47c5efd8c8d1175c44c8dc4a7ba759727107bc4fb2d7127bff4a56055"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d66f7defc0f9eabd6fe14dd80895e7bfe4e9dcb7390483e5b377518fb45029ed"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "31c3582091540e37b4d14176bdc7823c07480555f57a22ebdf2e2f4463c0737b"
    end
  end

  def install
    bin.install "llama-matrix"
    generate_completions_from_executable(bin/"llama-matrix", "completions")
    (man1/"llama-matrix.1").write Utils.safe_popen_read(bin/"llama-matrix", "--man")
  end

  test do
    assert_match "llama-matrix", shell_output("#{bin}/llama-matrix --help")
  end
end
