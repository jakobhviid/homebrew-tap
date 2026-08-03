class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit — without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "68a178cf655f6220489e2805ac900120cfb4069061b55edaa2da9928fc8a93f9"
    sha256 cellar: :any_skip_relocation, tahoe: "bbd840a9282f7c76f6e25b00e797754f054882cf7814cd894a0b8999782dcd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f9fec22fab625167f81957682fc894bbac3940c6a2726a0bc56e18b543ff71ab"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.3.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8cf4198239b193f941445b5fd958f28f433fae07f1ac18ecceb7e39c574ba319"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.3.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "26327f3411159f1839164dbe55a3cf4f4f511cabe0670deddda60562e1bc26f7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.3.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67a5ecdd1f7b69a42d8052b893225527d2ecdabec128758da75ebbefd04a38ac"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.3.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d1f3f7d08c801c20d60bbc70b3c95891c8041d0383a2dd77e73fe6cacdeb0fbc"
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
