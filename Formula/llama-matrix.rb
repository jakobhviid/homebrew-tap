class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "63b4861848e2fd8d59c21916aee9abe8929762663422582f7138d35794d20625"
    sha256 cellar: :any_skip_relocation, tahoe: "9ce1ba0169d186c25bdd74766596059da3b37bd81c05a1739423e9c8051506fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "925fd492d70a4d72679554b62322c7fa8b33627b7ad4cf3b574b55e81de11b20"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.5/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b45f79229ec29eb2d5876bda612b89d74886cf2ff32cd68db7cb40343dc16a1b"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.5/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "538bbed16853c0b75b247bed92cca55add90b1f838bdf722b6c0a1904aa6b25f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.5/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f3b815f397b81cdb2b3e7d6bab287eb3bbd143e72e97c8b00f3ba35f6f042751"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.5/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bce8e0b8ce77f50cf1bbd1062eb03b0dfc44525e9cc6ece98897338aa1249f1c"
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
