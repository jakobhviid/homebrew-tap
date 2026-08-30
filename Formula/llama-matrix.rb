class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.12.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e3da1208fff4a63d291a0dcd1d5aa756b9b9c1ff20c514cf887b95a61a9fa778"
    sha256 cellar: :any_skip_relocation, tahoe: "43e2017a429e540d48619c01a5b82b6dd336d64cd87f1949fccd15823064b3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53af60d396f79ea06b99d4847f8c29885fcbdd31165045fe5b7fec2d658d302d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "a0bcff0f5b1a7ddb62192e8b5ab84c4f50cfc0e9da1aed71bf7f9cce6fb6fc36"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "a3e73148a239101b477a4724f6e2f0247a4d6964e3ea2f427977f3e8eb399800"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ca9a67d06915796739f68eb67caea4ed1912229418307e6d29f7748fc23b27a9"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6be32f406a6764e0321a7975e35adb481c5f30eb433e0bc13fd3441b45b9da8d"
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
