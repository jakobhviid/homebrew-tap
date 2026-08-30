class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.12.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cdb4bfe7fd5e4bb36fe51967ad89a003da2318299ccb0b657d4af869ed8decda"
    sha256 cellar: :any_skip_relocation, tahoe: "4619f625ddb5e1ecc02b9ff508fb50d5ac9e9c43dc211e7f18000ea709f7d781"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "137076ef1c44ef48a8d40fdcd3c36c49534f5162ac3676616c8b9c7b103ba973"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "3e1a5212b431ed1ad9c6b01f55c10834ccf3d0ec6c925354df8ce41dd7a2aa3d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "911bdb5094f9df5ed357df82bc64fe25c553842e71b3bd32803d646c3296489c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "708cee47d33c16bd7a757af58cb9d4a31f6b54c94006bb56a9113735baa53797"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c62d32b622972877af5fc14e44e60be0dec106e3154b35fc8439f80ec9c590c2"
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
