class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "89ecb96246a0fb697409d15f0e10803007536ed18775706bd0e7ba7b9e51999a"
    sha256 cellar: :any_skip_relocation, tahoe: "52b0b8014ca704759c84583589920d7be9feb58b580cbe3f453aa3e5f3528bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7428be89fa051471a3dbb6abbdac452cdb8f684dae638fbabc9eebddab88ca2b"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "56b2ab8f5fcfaac29b886b6b07f97ca370d6f3840171d7c8c7f3a96aa4c5586f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e1710f7226d307fb3ddd16c1c6321ddf4c5aa18ec72979e3c27b7fc1b762218e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8c539f575749227c43c63d156fbc94422a32918c88d23264250a72fe977142aa"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b49c972932e1984945b47783428c9f291e9f9652c62328eb3a8a32dc9ef0c711"
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
