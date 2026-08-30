class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.16.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "73c27b70deae23d359d2f13326cb937dd313137d6a73f904332720ac492e002e"
    sha256 cellar: :any_skip_relocation, tahoe: "46cdc46a23cd16c70cb11ac28cda994eff70dc69273303b0ece81bb5996a86d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "068636d5e806105f681521aafda06620f7f8c9ed659b9e14e53fb89bcd9e04c3"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "76513d660da60e5599debba3c4f7e1ae6932a7ba622c4fb6c3fe48238da43585"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "3175bb98fce2c45005878c2170af2dd0adec3e3206ca5aa5f5e791fa061ee3ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7f1e7d9fb7db5260d26256c2316034a2de88456fb6df13d561b83f1b51a8cfd8"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1097b1531c4e85b7c9f106ad13d18d0e4d68a9f628a75da42bb8323a40e7aa41"
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
