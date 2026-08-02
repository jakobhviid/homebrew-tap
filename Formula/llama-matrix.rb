class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.1.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "93383e9ff3ee9a08c0a14e3b4278b8f97701b887071abffded0e5632ddf61e51"
    sha256 cellar: :any_skip_relocation, tahoe: "fb44165c3666815bfe853d911750c5948011f62641e8cf337856cccb5fa0b7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "46f2e78683ee59447043373664d4620e30aed2be16ce7646c2cb2ba475d9a203"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "e13ad7932d74cc803e4264044a37267849d2c642cee76c1f8b8251f37dc501a5"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "6c5cedf6c34d61c2be5609ed5dacf25a6c2a443b6f5be594fd0e264a4836eff0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5f09b529babda10818c05bc81ce860957061fbefb182ed6848a4a263e5def06d"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.1.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a182d2135fc38fb0dbb32400b9e5dfb0440cae9b15c14ff4d76221b1aea03731"
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
