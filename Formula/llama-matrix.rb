class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.2.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "1216e9cf7622e5c80c85bbf642e943d9edc0a90d746bb26fdbe10cf5e10eaf51"
    sha256 cellar: :any_skip_relocation, tahoe: "2d250bad65ca3151d77fcc4ad0dd4be32283f86a7358a73a378c3af1392a53fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "054783273cce54c927d09ce605c67d33e2b8499bb51beaebabb242dc42008e03"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "6262144a6ad494b37ac6903a5a398863b094f9c4dc3d94b968f88f89fd578d59"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "6701b414e56230e2f5cedd9d816131fb59f249ce32b36d11ba6c14a91aad1987"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67c36578034fe8a74931f83b684c0bc9e45a5d7251c2eb6cd70c87fdeffdc920"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.2.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6423f03d3ab5de3320e4e507b52c2de792e84c79ee1a4760336009b81b23e5d5"
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
