class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "0.8.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "590dbec5a8249b94db837d9e9c2cbd6fc69783714e29fd1df63c3b1fe99727ce"
    sha256 cellar: :any_skip_relocation, tahoe: "83e1883009645ed55edec2ae49ec10516aaeb7872855624ba3e255127fc1953c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1310e10f3d60237053bdc3538585c512857cadf97190403185cc27b341f83400"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.4/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "bb47e2f03b94546b4526085d117e0dc0f97f30f90860159d36727159cfe1b3e1"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.4/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "32cf3b42424a74106c1ca64181165ceeb16fb6f4af286f8fdecc201585b3ac2e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.4/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6ed596aca85d5d81c2bf9c503b32afceacfbb1608e63e9605991396be87d87be"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v0.8.4/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "63bf147de610fa24a859fb9303211733871225c626789d03514b81d2c7951f5f"
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
