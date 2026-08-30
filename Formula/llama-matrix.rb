class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.24.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a0d8eda6875da035b26ce765413efac7c1ae348d685f67c5fd7ca24b0edd8c41"
    sha256 cellar: :any_skip_relocation, tahoe: "c00bf14fdbce69fbca1adf38ddd62592d888e40e99c9fdc154d8096709630b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9c6316ad9e16f1624dc900dc2a7cf5883dabef66fd267674030ef5b5a2d6e330"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8a5ad07c21310438d36566356650d6445a367f3ef4399c20bc2f859094a1ee2a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "18d0aaacbd31833b0681df3966ca4ff507fba489aedd7743b75c87502fff26ad"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4564125f4f73428742676131f2e6aac107cc50b6f4cf468759377b3f9716dbc1"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "13abd407823875880bfecdde2dbef8c3a4f3eb0a792bd47918d3eaca1c7b853a"
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
