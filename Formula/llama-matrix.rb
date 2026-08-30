class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.24.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0a84b75fb9618ec9953f22e91621f2eda72fe1871b833aa683848905f2b8269a"
    sha256 cellar: :any_skip_relocation, tahoe: "499d7cb9c442bf9035efefad3ae1890ee60bb73f9b43f81dfec82206e8417624"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c352334ede90ac0d9a49b26dd0dea0d11478d646b2709f7effafc5cbc3764f0"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "65f1d55ca9f5ffb1602707b1122fd8d01c9b4074bead77387a0d6a0fc44bc19d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "4155ecb9d867b67d41ba512d8dddc5c4aa8b49ec55130719d210bc19542067c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e2be5510d58490affcfa41174fd2b322ed8a14bd95b30681ce12d48c8b508b0d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "39fe577134c18ed6a6667a874b2a80f7e378bd77c015c348f3c5a739438faab4"
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
