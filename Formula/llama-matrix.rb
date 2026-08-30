class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.9.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2e68b47719b2122d3e4543a50b80aef659347574e2e5657e5c8ec5da9a70bf6a"
    sha256 cellar: :any_skip_relocation, tahoe: "5123a55e8183a6bd265b590f3c1db899f94c78bcefdaeb854882a5ad0e4e0f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "892b715871954f0b018491c2fe716b2651049eec156f99afea99a7309d5a76f6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "da593e4079c216a348587dedef0e0a1c74eb2efd1753d7e0957bcb85bbafe75c"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "2950494481290085aef73dac96b10d0f4abfd26e89e22c06932b48c8f831a718"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3f0b6cf1590318e5a1290b853a13f1c5da643e4e75949e8dca6699c0dcc7a578"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b4b2f1cd70a6aa2960903f01229d21e63c3ff11584e7e50b06a83625e06d5475"
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
