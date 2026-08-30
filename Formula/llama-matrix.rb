class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.20.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.20.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e666f6216437d85b75f4963593118d38cd96bf2de851ef8ec1ae3075ba7c0ded"
    sha256 cellar: :any_skip_relocation, tahoe: "a7660b9f1e522536345b8c29130cc9d1a9719b46e7fd2dbcc54adff17a117490"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9513292b0688b3bbf54ca4190c9a6a3e5c6ca82413c6df70d013f15e013ddcd5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.20.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "3c16c2ecdca61870683a084721b2c5690aeb5122723db5d76169df0a8dcba4d3"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.20.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "dc4136f7f7ce3a1c96873aea1c79c486ba0ca1c58ff63b649989f69a3058c836"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.20.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a27201ee4e0501ce6b53b412ac9ff3b1014deba468583f70b284e9a2fd344f8d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.20.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c5bfdab5a2ecc0e309f54eceb322982fb0b2d1e0085adb3dad2d7d67bf282c54"
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
