class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.6.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2b93112ac28d54c9d137f08190d79baf22212c8216d3f45924d6e804c34bd2fb"
    sha256 cellar: :any_skip_relocation, tahoe: "6842d4d0d524ef0db02ef8967dd4e0baabb23c7bf87b9a675837da534fda4bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ecc7e36d55dc2697e6aceca3cf3f8f5baa33ca0c3e3ccb8598bcf7122edeb9f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8f8a00b38aa18021721cc739b95ec3167fa12ad931bed8dc51fee4739a88beb1"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "63fe6860614143209f7e50b90ac999502c6d5b8537735fd00a6222055dc1b0a2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "324e34664e9320ecc74c88faad894465070a59e51ea7860c1270f17d98e26cd8"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dd9f5ad2b0ae1ec1c19c28dfd6645ece90ebd50d56569ac38a524d6091a09cc2"
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
