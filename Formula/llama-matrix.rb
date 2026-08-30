class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.13.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.13.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0007c6c33f3f41884c17459f3e1d472735b028dbfe69af34a548f76f9d7ae9ae"
    sha256 cellar: :any_skip_relocation, tahoe: "6a77422f1ab4204fb81bb17f903316e37bea94906b0dc846100906f6745b6d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9871611eedd4fe2cf7489690b9fc9ee1dba48346365490bccc614817802a290c"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.13.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "a3b7eab742a40fbe50b6135fc69c8ed1696b663aeadda7dfb0ed6944853e5945"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.13.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "870a8b2ba7bbda7d8532bace54c1261048e1dc7bcc2142a586e58d88d2e67b27"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.13.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1ba69cc99fd79f28e7ea650496fe572b8d0ac5ae4220a48c115e03b16323ff1c"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.13.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fab86e4f8c991e1237edc2b7e561e95714aabf2fa910897bbde19acb3339d8ed"
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
