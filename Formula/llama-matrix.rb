class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.24.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "57fa1bce48f13c5e47f90db555d40d148aeaf01a99a55544fccc0e57e8cd4ae4"
    sha256 cellar: :any_skip_relocation, tahoe: "ffebf617bf044344d1dd509d7a5f21e46427027e74d2537ec5d5fea7b146e8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e4f398aa8e19866d179b2aa23aac40e499054d34a1e0953baf662dfe3b644c4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b9c95cf6ee4d2afe7ab518f9ea7661001cc4d027069245d581796e4c09e1178a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "b96ee7cf05cb3794ea49ab8eaf477d6855fe5605976f475f7fd5f349ebf98e6f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f9e14fa3e6ef181441c8edd07767a16cf757b148d7ae37fc73e3325f5a4e441f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.24.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "049d38565e1d348277e090b73f1d7c36a63eb1c674a052ccd49662d5e4866a72"
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
