class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.23.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.23.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c152cba755163548db48550a0865416acf7145dcf736e3f9b3817e502ea854b0"
    sha256 cellar: :any_skip_relocation, tahoe: "d9dd882e70e17056fcd8e26edbb4bb0fc2c831a9937ad960bddeb285443449d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "54c5cfd668e3f28a32422d4a1a33f5653662bd814e524624a6c988cfeaeb6f49"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.23.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "c034d4af7acd218152bcbf29be2c4faf88ea861a69bc0c234f42033d9a288a01"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.23.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "b889512ece165c32bacf661f3781cd2d98d89056557b87c005aac5e180240f69"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.23.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "33725918aaa2a9d147e5b276cb3af561137485bd125557fa0badd83b51fe9cfc"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.23.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "218a33621f70ca8c82fc841f99ce5a474ec0a81bfd764c7da331534717f3b233"
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
