class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.6.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9b1e860aa9c0a97f044f87d47d4072edb9e98749a903696387bd1ab60f2806e6"
    sha256 cellar: :any_skip_relocation, tahoe: "f4e7c677b6867176462a11c6947a692ab7b4ad6be8ffa4223ff62e490d474f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9e2b70805e8b019f45ca1cb11dc2a7fd170d1cfa7ff70f3312482df4e50bcd6"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "3db7e92a92975438f6c8604016c1eada4cdb191104641ecc1e7228f3a6d5dbf9"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "ace2910836e4203fdbc0b44d0808ad41309818068697e48e23bc97ec9247996c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "44355310c5b820d1c36cbebe43dd1f839b3e4d8f62546995f9641784cd7fc49e"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.6.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6d9f4e560a111135224ad829ec73b003c2e6a39ba3d4d044ca28ec08e2c91f83"
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
