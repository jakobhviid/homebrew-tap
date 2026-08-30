class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "642ba936999cecdd103778cf855aee944db42250436188fcc263738c807639b3"
    sha256 cellar: :any_skip_relocation, tahoe: "5dd8e8dcab04ba4a09a9ff14092adeded6d51406b56cdd7262037ea2a1e025e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d30c773db700a9d854020087636993c92f9d8270f1e3803a609947c206eedf2"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "95884c875b50d9fc4fdfd266dd39bf79cb533c40e3715b3ba2eaabaec0c18991"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "c7b2121e65b9cdf604ce8e48913c04f429a80b8cc4574f3f87ba5625440608c9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d486a06334aa7fb21a22ba6e9aaee8464f46fde31767bcb51c0bb20a62d2bb86"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "baed467be11634a0518d5bd89338706e971abb753651b4b3b76dcbb0a29f896b"
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
