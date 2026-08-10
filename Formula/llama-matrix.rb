class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.4.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "632187d063f7c4b4374b8a350b1f45d7499f4dc928d9af2bbf77a73b79b77980"
    sha256 cellar: :any_skip_relocation, tahoe: "2cff382481c3ac05efa531ea73a27b58ece6695a3514d70f17372947450b168b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4076fa641452dac4d41b5dced1a01a65262eb612b968df5e313ed3f1535185b6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "f0acccab8648865271f1e17d1f6c8d4d6af3b7b8b5cca99c79f4f827e66bfb1b"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "01081e01f3f811ebc9feb7deccb76f8f7a467c20c21f8dab3464d1a5b354e02d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5da366788abaa586d4a3dada792b07a7c0defb5d33dd84dd36bd94ce8296c118"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.4.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4e9167cbff7d960820c927c6c4e61197b66ec5c888893ebb8dacee96fbf0662c"
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
