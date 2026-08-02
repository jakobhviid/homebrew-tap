class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.0.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "33d946496dcfd699ad7866451a1df2bf48754c29dc278d1e684d6dda446a7c4d"
    sha256 cellar: :any_skip_relocation, tahoe: "2cf5446a3124debc16b8236f40c117207ed3bd81f63123d9a589fa188b9eca18"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8915e48d732af8fc15eb173d78fd22fdf908ca2c6d2729356c36090c26b24597"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "f7ba42296728783c493e6819ed19d5184e0f186d0d146fba19eb66df294561b8"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "34973bd322b08bc4351bbf98d50ab3325790e85227be9438725390d35182018c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b7a29942b75d622b4c748cc8087c5cbcc92e984ee694f5a20f356da02654b874"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.0.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "859ddc4a0c1a9f24b42410c0ca8eaa2a6d4732305ca211eb46149c57f11dcebb"
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
