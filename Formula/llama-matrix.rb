class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a62c00e47bebcb3a9fe9c41b12657bff7bb9421f967d93ab7d263c0ec8701e41"
    sha256 cellar: :any_skip_relocation, tahoe: "0270f5f208fa7e431a6e506de82aa4a67f2740a01edad0c421dcc0d828793ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "da37ec6976ce4d880c465da74976cbf5b2c894877610f162a8d5f20e6e5d60c7"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b45cfe74187fea424f2c0126140a664c5220f35a121462b6cdaea3595bb22e51"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "674234eac8b4c608edd5f64f232d56dd0f8b830eab327f7dc1cbb602a0915f67"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "91d1b87a18a899fec619b758d9afd8a6bb9361743bad33f3b51dd1e7098d91e3"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2cc6ad4ee9174d69f1e6c5069e4238dcc6c606d1e40e8532ea7bbe70b5f5cbe0"
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
