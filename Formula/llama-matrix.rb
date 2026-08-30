class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.14.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "160a791a03e330c874e3c28122b3441846b947edfee615da84d42300dece8f96"
    sha256 cellar: :any_skip_relocation, tahoe: "29dc5fb265bcf7aa5960d65efffb5455e00cc9d98eb3558cf5f29c143ae9a98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "534555b7ca7f06be717a23ab78103b298a3ceeba67232c515476f00f3535f386"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "6271995c09d54ac87e4dd47fe7ade891896b4f91ce54c57671b972a055a7f59a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "b3e49cac232075db4ae2298ee8d6353e4b41eb408a3897b605025d77a5bcbcbb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cc375b28bf6aa7cf71647c3068955fcbb6e343fb2bba8939c1f09ec8f3544ccc"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.14.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fe0b0bc40d07ff7846247e47fb9f4dc584ec5b9885707357debac960c160fe60"
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
