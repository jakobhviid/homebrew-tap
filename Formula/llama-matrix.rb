class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.17.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8f7cf3752d8ce52344babcf0f881c083c7e4a491ed7f038e4aff5b323d208d5a"
    sha256 cellar: :any_skip_relocation, tahoe: "cb45260b4ceae63447fab33cb0544dfd8a1b91d24739425a8fe688ade105341c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "77099f67f703c90a2de06f9f8412b81681cc29ba7e58b365b64e6ac49024922c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "82e95fff2f8ed26581399301a147373adfa02ea47a577c2c32f36c2aba47cad5"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "228b7a634aa99262e4d54545eec6a39e576e1928593a6f5295977fb6405604eb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "73f9989d7027201d462c0dcd59f1b213cc2d14d11beb7e4492c5280966377807"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7dc488cecff61a7be03dfc2e2933bb97d6ee2693c9c4a609532e654b6e798f37"
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
