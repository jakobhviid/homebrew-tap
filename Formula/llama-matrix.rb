class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.15.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0a0458861109b4cef9f09916a4750e576b33c0daf75c48454e6c5892110bb7a1"
    sha256 cellar: :any_skip_relocation, tahoe: "c09f561ea4ead574a0af5dc98ed13b00b26f0f1e46cb7edef344ea10541a9e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01195bd536191c8d75308b68f9e505f5cfca382bf8dce53a9605f0226f286304"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "fb9b2cc7ac1936b5205da94cf97603f4560cfd8b93012df954d4aa20d57ba5bd"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "78d5003b7e23848ac95a777c17d688a43d5034632aeae48ec1a1308a81326476"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0a6c573179722016edae6b4d7cbd7b0b54729469788051eb1a86c176de44381f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.15.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4c3f5b54126f0e97f94b31490d1b6af11be4514884043118381d85483aacb2f6"
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
