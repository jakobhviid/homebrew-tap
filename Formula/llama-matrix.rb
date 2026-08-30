class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.15.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "423f2f303c3b4ed87a18e25da5a2a02e3a4fbd4cfd2b1b93794bf0f15ad0ba23"
    sha256 cellar: :any_skip_relocation, tahoe: "728ef0933e54a74bd2254351ba3ffe39dabf6f63d5f76a25d4b672784920c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8732d36640003776b786a6ab06be9ca130df751d9ce1805690b9f53dd3676c3c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "0404c8d898fbe961e4ac5a7aeda40be477b58106142af6d92e3709ef7bd12da9"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "f4d0a254da5fcaca8fca6f37dee4cd03b34c1fcca870862a22df3bc22c9940a7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "32ff477082cc7b9b57cd9c78c3edbe08bc9de224409ebd7493c1be8baca7110d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ad9b8af0cdac289ad2e5b30bffac9e85ed6446f9efe2c2251ac5a9099c15be7a"
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
