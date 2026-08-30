class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.21.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.21.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ace0d24a36ba21ae98a151719485d16da7a0076b6a4f1717bf9f4482b432caed"
    sha256 cellar: :any_skip_relocation, tahoe: "78fdf87306007ce0e7781f82067f78212bb5ad59fe421675bc727e34f0c3e298"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79d23717d4cb7bfbb3a239a65a63e8ec5ebefb142583edeb3609fb22925e41a3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.21.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "836d095856ba4f33599d91faa1ada7ba03aed5395b92feb7a532629210c1cb0d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.21.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "d7a33962b957e9aa4772501877a87b2b8dfaa8dae6a4515e46be1c99ad433e19"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.21.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "552eddde3ebaf69cab950dad9a9d456c35404c033b8c97be1ed5c6a5099d7956"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.21.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7721cffa1352b204c8d97f9fa72908c56653d8bda713fd2eb58cbb54a97e2bfa"
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
