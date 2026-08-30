class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.7.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.7.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "dcfb1d631d7978ce41bb2981140815cf276366d6605ac2f392f0a656132133e9"
    sha256 cellar: :any_skip_relocation, tahoe: "98cab6682a889d58b92eace7a8cebb02076c35d946442b021892faa1499d145a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e111ee6be5f3a3e264299d93eb5128006032c2ad2133b5ee3cae42202f00808"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.7.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b32052149f5b0f0d49d024a563f868e0b7a269ea4f6115112375f678b8e387b0"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.7.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "81c3192b0885a0ed11aefcacfdc3e35d81301b5332e6b1d7a7b394d82cbde245"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.7.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cce1448be99bc05da59316b2b2108a1488fec7b3fee578999eb82443dc70a86c"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.7.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "66c0ff4020b0984b8c6f9585a2448de5fa045548005a609a39b2414aa9d51d18"
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
