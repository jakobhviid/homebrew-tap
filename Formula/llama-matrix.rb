class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "f7f7ada9cb43023dcf27398f855ef90585c801e2277931b564853a6786cf73be"
    sha256 cellar: :any_skip_relocation, tahoe: "4bf05ee9735bb6af4b1e6578b7c5d598d4c8cb6eeaa7b1eb76841b0553491940"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea82522072706e43b300450b26c24d5b223551562537ef724c144f7fbd54bc27"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.4/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "0af341d11ce7fff9bbd88ce956af5601a56d5234729a2a28bc4994cb6e77b586"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.4/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "d9a9270a4e82a08fa52935eafac977d3716c52a6acafeaab8b2d37d0482bf5c5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.4/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "18b1dde3f121fb62fe74e73702dc1930819f2e173e11204b3dff1c09ad4a73ff"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.4/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5dc05d2b598a5bc4743621b6d438639411bff364d325300221728251b6d67eeb"
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
