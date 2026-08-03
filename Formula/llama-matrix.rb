class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.1.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6a5185bf19b7d65e95b499ae7e08dc1a6754aaedf698de15f5a9206c995ab2c2"
    sha256 cellar: :any_skip_relocation, tahoe: "9f8ce09ff92cb7a1055941e62b1e92b619fc87fac766ddab0f97b1d1d4080e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9fa76646befd03f9b8b2345fb109d60b2f4764f6d3bea5eca75baedc5211cb5e"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "d8c4e3aa856237dde00b857a09fd61c93b144cfd04c2b4cef2c90ce4fdfbf66f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "5e3495a7aff4806399c854bcfd9b7c243260b78c1e8b28e1e162fac14d7baab5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "362f7910c302240637cb0965641f64228716a4f9ff54541c1ee522652ed0e624"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0316ec6c8b679a524b3d86120ee8eef7cbcb328129d8e246becab48ea0aebda3"
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
