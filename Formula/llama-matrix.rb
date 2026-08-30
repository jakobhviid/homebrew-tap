class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.6"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "493402ac0394cad4cd81af35f4228e5d1b9f2c1467b40140df484890233e15b4"
    sha256 cellar: :any_skip_relocation, tahoe: "96b422e5d0cc440808d26b98e7ef31fdb97844c53cbb9ee57941f0e96bfddfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7dcc0d2e37d7acab1f4421e00fea1ac6a211c852ac582dc3341217f86c7bb5b3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.6/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "1ae3da8fe28319f89c3301c345a88e6516dddf26b67445a59ba91063455630db"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.6/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e6cac38eeba9757b0cdf8f1307ab60058b34c531eac877d6de10a9a5692c789c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.6/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "57a9e878247ab4604466760fc0993aafb478d930098ea8069a10b514dbfbec42"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.6/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "82c315250edc6c7bc2cb6e0ea4438707bea3d0875f569c7b2f19951aea0bfbf0"
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
