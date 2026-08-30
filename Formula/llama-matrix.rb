class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.24.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0ecd2afcd4975d73600748c754b015a6c889ab6c4c9aae6e35877dcd1bfc4dbd"
    sha256 cellar: :any_skip_relocation, tahoe: "0c6b45597f8f6a7ca0617b030f8729ab98d5362e1d0db0cfd6391245b2f3d1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "233394a8c787ae69c5f05efc1614ca35b3fa4eb05d191c816bcc1e9e24c3ec76"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.4/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "9f3912395412b0e2d81bc3c5d7169521d6c558c2caa121a2c642df5213bde9dd"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.4/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e533f7db509ea4f35602b37426f337240cf3bc9d202b6a6065a3154ebe5d1829"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.4/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "280c56b907d0ae814bf5cca52f49c5aade88032b1fee8217d5795745be13dabd"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.4/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b0912923e3d96446373ca74820896d1bb1cc54250191684142b77e15c133acf8"
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
