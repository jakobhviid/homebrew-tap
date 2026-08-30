class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.9.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0b76b7d0444ed29d11ec7d5f3109a54dec3641e367837da188f9360f4249017a"
    sha256 cellar: :any_skip_relocation, tahoe: "3c8249b6071b03c0727d650661be174840f3e09bd9c6159db454bcfe694ede70"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "77f3c445c2ed1a4bfb70b627cbd90d28ef0e26c4de08e690f246e10e78fb6336"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "731a8c58882042de0126336e6b418e8b3c54d3c6a4e6a6190e7dec0983a02102"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "ea2474e775daafc1d294d21fb30a873968698aa0f4e7a423768700f4301ef32e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5f443dd58cf79bac91eefd3a69b548ed07c3c0ef3e6940b775f63d2a77b0b9c7"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.9.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d0be98c49662b201d0fefa0659382d2698da0e1ae5b70c64270142c0ef70c7b7"
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
