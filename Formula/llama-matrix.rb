class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "0.8.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "98cf61f22bd9be21734d04227ca77ff1379c2d1ae4dac7f2e08a472cb04fd77e"
    sha256 cellar: :any_skip_relocation, tahoe: "ddc51cbdc78c28838f56e0603dfc40b19750bbe69db759c96c8cb800fd5bb9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "16fcc367e2a494feffd1be6e46dc3f1cc499f7fe946177092c12a64790eb1ef5"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "cae92a171e1041dfe19399028248bd85ca693cf505bf6d829f156232b6e5c461"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "2ffcb69ff5d3874598261d3c2c6da7ad6f9fc6fab05079fecf9e1b1193493260"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f65ad5af310c571c0e70c439a7b0c2a60a4370a1e9aa19aabc6854e94707898a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3db23a48c659dda0c981a20163a4d4e2a21d8b56a2823c0ffbfdef39517ee6a8"
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
