class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.6.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "afb83ec7a625332692a83c97531e1bef87c0c697a5acf9cb8d86fc6401789b38"
    sha256 cellar: :any_skip_relocation, tahoe: "3ba13f93b38fc14ab997bfdd7db9c14a0b0824094ac7f4a1fad6e1f306facf87"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6bb8d98c0435f7a6423be646d4e8646e26423508166a872c4b0ccacf3dab1a89"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.4/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "eb4afcfe0e9a7f2c1afd311aa594e3fc2d57546fb0abf299682290c761357ab1"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.4/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "98e266c16096bf58a39a5bd9635058f0df904952d0ade68d62e4fce2d593e50e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.4/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b71c0bd9552d4177670eacc94b137eb550541446665e0de466a01e05dbd170e6"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.4/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aa72a7ffe5e4caddd3351a8c0fa3bd5d78721d8b2aca060b5e08c29c9e901778"
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
