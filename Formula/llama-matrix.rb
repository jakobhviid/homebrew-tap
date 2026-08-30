class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.10.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "19ea0dedd9c1278f3a5dc56512985f34b549b3bf14b995c3d26058e629a024a7"
    sha256 cellar: :any_skip_relocation, tahoe: "3c83484d6f3de39cae7601535a75a0afab49d0125a3ccb1651e884b90de47ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a651911768df4c29e5d3fc97300cc76b8e50f8db06fe303893bb9348c7820aa"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "2760654ba51ecc5a5cb26289593ab02c2dbcff26d7da82d7f0c709226f6c4036"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "3130b759c31effb0465906f0dc088cbf270abd89a61c26264979b039ba775127"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6585e08a7469f83afc02f5163780c790749f44cd44d3b64949204826c1ef8ef4"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.10.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d6e0c7692d6c8212c8c99b0879c79f28ba6cfe55e0cf2a3512b8d642f6ef3c81"
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
