class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "0.9.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c4bd7d6ab86433676d441a1f2d1693c9edcbe0f6b2c8a854f7c839c3cb80a755"
    sha256 cellar: :any_skip_relocation, tahoe: "d3ed29a2f74bdc39ddb83d47a0346146fffaa4c8c135024cc3bb6575c4c00a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f923196dc17d5ad8ac50396a95f8a81acdccd091597a792985766142aed56f6a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.9.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "2f64c29f589a3b82aa37b79c597409e7619b507ce3c1f550b01a3f78506ccc37"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.9.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "720b99a02767f2f73a21547ff5fb7623718c749e7d7ee784c3b0addf9ab15d10"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.9.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "82d9222a3800b0d425d2a0d21a6220955b279d5daf56119c3d596bd291fcb599"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.9.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "badaf07747f8f43fa7ddf0596e34b7a2ec369a408a4f16c3af026981a4781d10"
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
