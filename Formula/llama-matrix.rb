class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "0.8.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c0d6edbf9942b1a4d015f7b67dcb27e2ea00a1400dbe1b4345863e50efddb881"
    sha256 cellar: :any_skip_relocation, tahoe: "1b09f143f2a74ec23326370604d965e18ea09d006e472a5022e932bb6dc95dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c67d19970ffa2a9be2b2a6d642c9c0f0e51e6523b7ff88443e623f4ba7e0734a"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "bd609704fb3261aa3b765a64d4d84bb3747616791602439838f6301386ed6733"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e5bf63246bcc8cdbd51eee7d4798f0d0f55ac5e7a40479150e8020eba3dfbfa0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "016ea28ff162b89770500ffe69b839354a68715eb4f202e228cc16abb75b1a15"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "44af2ded1aa97fb8f3af298a7fc2254bd2a5e5e5b42a839dbed71708b097aa9a"
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
