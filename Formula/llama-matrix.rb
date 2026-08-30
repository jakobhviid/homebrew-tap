class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.22.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "05a9bc83b2b8204b6cdf3e8584eef0fb1698f4ec5cfc08c1e1e514a6544043bb"
    sha256 cellar: :any_skip_relocation, tahoe: "f467b3976d2f7523b67c762a635cfddb3aa57f96ce5119d5632331231c0ffa66"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5bbd6f977c39eb2e34878b23fb7f79084d5f9e9ed991a4a2937ccbc375ce269c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "f5a21bbc2728d843a171d18d98439262aaa728dec1a31f7f68edee18a3bc7daf"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "c0cb8545f2f2aef8fa1dc9ad0482ed6e6a7f6006fd6911b6588c24608b9c6464"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "35e830bbf1c0f4afba970d285074a5e87c87bb32f8342d59d6a7bf3d7c2464df"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "71083fba447f532bb67e12330f81ded9f8cc5c52fce94913d1b5fc91dec5ee62"
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
