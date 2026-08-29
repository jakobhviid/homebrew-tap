class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.6.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "274bda73d1602feaa318e53e55f7acef93cb45c0502cf23a07e8446bd5477935"
    sha256 cellar: :any_skip_relocation, tahoe: "20e2549d7425902beb0b5961ae2cfd09945c2c5052a754f7276ed1bd8b9d3d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94e3107965c1fb0f1a8fd8b323125dc87c1aa6d2595127eda85f72a682c68f68"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "a7a5fd41993a67aefb8bb9df61e1dbda494ba0eb58dc122bb3b907b1c36b3cd4"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "461c6f4e0fdafbe974b80c1ae22aa0b540897ce6fd65d0c4a5ebdbe3ac665fec"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "381fd53183184d4dc4261eceb04e802eeeab26da4b4051d3a135fcdbb3782eb6"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9101b7868f8559e74e92b303db1a9b51c1c6ed425a942ef7684e2008984de223"
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
