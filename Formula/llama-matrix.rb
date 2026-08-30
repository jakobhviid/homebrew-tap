class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.18.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.18.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a5b68781b7dd6219ee05a2a0ad1312a3f665e2f01b1dcce439194db69d6c9cad"
    sha256 cellar: :any_skip_relocation, tahoe: "1fdc2c3230eeb66fb16ad6eea806cb42455df56009e18e1d33ac61eb4046f647"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "142548da5ff9400af9095b72f213ce8763d32665af48f896599a7769e552a786"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.18.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "3dcd628985b0f000917125c8e2aaff46082e5db691233ca4ff7c5ff3201439db"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.18.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "a44525183297b603d91453b564e21a085bc675efc4fb7234b8c23fe2f555217f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.18.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4773bf65dd8ad199f3f2029511e2b10f0429f77412c9b627539711a369299da2"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.18.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "495bb9c516ea9cd27a142049ee6066c029cddf3c0ddecc51f7e4cc0aa780d079"
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
