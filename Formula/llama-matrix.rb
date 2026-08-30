class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.10.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9b16a582d38be9345cb58adec67900d2fd0616772efc9056541f1292854f3b71"
    sha256 cellar: :any_skip_relocation, tahoe: "ebfeb9b16f381ee81a40743c657733669ba25bc940a7dda7de37a6b332641a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c25e5447a0654b847b7b797b6cb746d9911d481cc5b50e13ec058e950863db57"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8be79eb0812d56a2a1439c34c0b35d3ae396c64d999a2c4201f0c31a437ea687"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "3779ce7898b313cf3ef790b6f216db9b949e12853fa8c946dbda073c5afeebd6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ff6dda9003df03da593ce37217ef8f58e963fbf1256a4e84b5268009d6038b21"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1af612ea7c1758759b51c1e61a806d78a93c1083b13dc436b3f2af5e426d8ae1"
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
