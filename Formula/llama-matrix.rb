class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.24.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9102f672414667ab7d36d4869f28c5dcf4ca0f935c7b7f6ac2bec79cc47fd4ed"
    sha256 cellar: :any_skip_relocation, tahoe: "4dc8191e9f5e6cef483581d3ad161809f9e6aa88127d24e50d57364011e216ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ada7259b424e3a15445f5067dbf315c1670fd18e5755ded3e4e506b7685cd29"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "9933d0618a04e08fd2cb305de83ef61f47fce5cdcde67aab7ae3cb591a5a5373"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "a7d30c71be24f65978e9ffe9e946d01bf031dd39d7d9610e9ccdc0c690eb24e7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "be50e8102e04adb5ed14ab59cae24627e5c3b8b5f7cc790d28385d9f77cd9234"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "93185bb66e974c37f2b0475eba91dc223507a4ff1e4f093364486345511e1363"
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
