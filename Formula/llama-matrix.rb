class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.14.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "99ce528fef4ab6f35f29c30a30821f2cb655b2b5a4dbbb18fd63a920e7e1314b"
    sha256 cellar: :any_skip_relocation, tahoe: "7ae54e0c2bbfeda23ee67dbe5ed6f7f7faca074885c17d3c90ae6e2e9c6f04e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4ee59dc4d80d4f7e957fdf95b51dc3dbaef5e870fe7e9699e624c81515f9e7be"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "3cb17600610e8688855d99880c5a5d38003aac8b1f6b8c601600c82535ae98c2"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "c952c7a2fd32851add12e3e5827a11f34bc90743849700ad4b4d1b2f389fedf1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e011912b37f9f11f9dc51f46997ca5ad41c74750feae64a2099ddda6a65efc09"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4d1f84db6a50b933ddf8c17317f7c32be10e5bec5f9dbdac3728c33e4002ee14"
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
