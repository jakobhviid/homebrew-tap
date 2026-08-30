class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.14.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c652c478b52f67c34d0fcf09c8885173575db557087c02ae0b0aeb21f85ad74a"
    sha256 cellar: :any_skip_relocation, tahoe: "408ec178cb4dd6302a36d23f15157ce5878fe6f14dc37b018e72d32f7db7d1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6718eaa68c2c6cbc863117e6d2efb1ce7efc65d3aa6ca148145ab5cecd9c269"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "35c61c248200a493999c79d470c49a817237d7db81e2c89b6eb484a90902ede6"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "2ca52335354b7c70656dce9f1b0d35c4408451eddfb7f4fc7b85513afbe825f1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "25f7970e77f64d775809b65667b05ace39ed097612a460cc1504a77908dba234"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8fe19509c1237c097ffda0a6850a330fac3dceadf270c9d949848fe5f119c1d6"
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
