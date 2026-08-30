class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.12.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "50da4c16a55f38c829566b78c11a785f62d8f823543f1524185ddb705ae5920e"
    sha256 cellar: :any_skip_relocation, tahoe: "21e961d2c2d83b0056086cc01009cffcf72bc474a4db666d122396e45bd5737e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "91da739046b73086634e583159575fe3efa1a81f1a16e54fd30bfec613cabfe4"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "5c58b43b434d80cbba8b5d7dfbae67d044a0cb70e8cd5c6b51c7eb8cb16229ee"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "021fa79c51a36aa3ea6fd72b91c4de0d92da5af70df9b7e5dc3e1e49fa8a7969"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fb04ca69d587886438b6033060e06eaeaed975a01325864eb6c50eedb9561221"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.12.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a879312fd7cf91d3f62e5ec0154ba71e74b66cadbdbd7ac3b0cabc42cf4f8c69"
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
