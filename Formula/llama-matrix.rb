class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.25.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.25.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "4792685a03fd3100fb5058259f6fef0bb8e54fc58c34dc442fa97d30044b6cba"
    sha256 cellar: :any_skip_relocation, tahoe: "8ad0228720e7d223fe14a34aff0abe72e8cadffdace27e3336d5195bf114d1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c450355b1dc05d6bb335f5ea2217eea81b6c6ac2f0f1315eea2d9b60709cbd0"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.25.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "9939b0961c8b199a1771d5c9008bf71c3ed545aa47a79f70925a16a756b12a4b"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.25.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "ac8e96225a51e0375fb9f60db5e0b89b2d29e4ebc31601665ae9eaaf4bea7f1a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.25.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "956276d2160cf0404cd895eb3ee3d3a2a08404c0d8f5d10c07d5666ba2e60104"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.25.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "571e26ae60d04c6d5ccd66920b43ac9c0716dce8b78f29e40060371c9e4710e4"
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
