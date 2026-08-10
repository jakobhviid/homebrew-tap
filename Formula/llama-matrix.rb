class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.4.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "15edfcb5fcd9c76cb600a624db7c8bd03ac9040f1af5aa86b2c127e51a627326"
    sha256 cellar: :any_skip_relocation, tahoe: "2a435734d9887319e36c395e9efefd4807b5162594845889f77b63cf31c94735"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e0e97ea4169f85d84acb80891a0b7fb13cf12ccc7b5683738a5f645437a6b7e6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "511d0132af510277d4ba1ff4059a0a3cc64320af1c63d468014359553bc946eb"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "d75e67fd09de1a2298dd03cc6f0e1a0e9ebfa31a582cd118352ef7d340fe8504"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a0d64d9eed26d22950faaf0219c7ad05a106e7738f666630cca2da7794c00f31"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c2248e42c2b30a31bff37acfe2a9b8167ac0da3763c3c482b250f7b5887965e"
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
