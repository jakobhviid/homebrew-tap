class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2f594e932ca6c00432ab5d811c1f507657cb8e9574aba3f96f72ec8477230ce2"
    sha256 cellar: :any_skip_relocation, tahoe: "35f321f83a59f43c726368ec911d6f18609b4967d95a6022899992cd805fc10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "940de3e90df2ac10ba5db186ac14d483805d78e489ccce4caeb0977e6514c654"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8c1b6d8c191fb284d2760fabdc065102ccf7cc36baed273ae336980a3305fa91"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e9b507ecd565aac8a551851adfd826c3fb918384f9eac5aa68db03f040145046"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "761879a7d67dcafc588dc72d1cfa31091d7796a439d8c9d334d1131b8700fda9"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "40bf587a5f423b3f939beae42193561de28216bb28fb34af599512c38950e391"
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
