class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.16.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "91785b47723f7659246aa5448b74cc85189fe0ad8792b2b2fd316869fbc283b9"
    sha256 cellar: :any_skip_relocation, tahoe: "388fe046244c12d953ea68010820e78905b970a0ec0108202f9658b58b15684c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dbc14473f9f3b8db51234df3adb5220ad63ea470d7473e8b552436bb1b6ea41f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "eb5bbf88642ed12d8e5be67b13200f249486a82f0d1f1ca5048819ce2a3c5204"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "823d38370d037cc9a21a0cd04b7d02b48a54f826aba195e4ad28ffaf4384ddd0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "90354f1a78cd262109e4c06a38f08a4dfd5041e0db3c8d63a92e571f55cf9554"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd09a1c926d816d429dbfd7ba7ba926dc706139bd97e9682850ce73eeaac494b"
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
