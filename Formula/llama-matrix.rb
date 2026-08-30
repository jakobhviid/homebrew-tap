class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.14.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2d98e600002da5ee4c8e7a2f0ee5052be19ec19b5892300ed2ffed1299a6090d"
    sha256 cellar: :any_skip_relocation, tahoe: "bb29725635c0570a9c299e2e734d4848136036432c66fa589cfea3477f9a8be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c975ebb8e7909f6d266666a9d7f3f4e3e6e2a09d0351fc2352c847832e969f1d"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "e90543057b42fb9a9d1f50f7f173072d100799d98951cb639b3e270a6a73f256"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "5bca864313069eb125ebdc2fb0735f21754cb3b9241e73142d20bce9dbda6904"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7ae8733fd8f7846ed92b62a8082b5dd6fed7bd11f1ae2aaecb6a0d5dafc8c031"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0bce1e5171afb78080f953569f1e7e96b8f9f57cbcfeb14a2341dc74a201c622"
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
