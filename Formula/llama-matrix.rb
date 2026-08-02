class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.0.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e44d516e30d238ff034260a57ad8169c71f5ab2603ed07751f7bb99c372dfaf5"
    sha256 cellar: :any_skip_relocation, tahoe: "e5ff759dc9f14141aaca16196d5793877ac9c40fa22dff36d869aa9e59671b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f3fb00711d7292e5da8064832cf52ddc30f75ab2d4ea6ee9f7e84680dd16ef22"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "56a83656a49cf870b88acb6226d6bdd997c5a5c5f2197e1476b3a76c0c54ed64"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "ba344e9725d70f38467920024f70f58792a3713a4e8293c005691fbe9a6fca63"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1b187b2670d69dd58c7cc04de9797ee01d5a24788607d2b620491ced0449001a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "698d9189e8c182ac54069661b3e92536155ca1e5fb1dab3ae20d30c503d13ed9"
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
