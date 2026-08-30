class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.16.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a0b92bf8305a1dd091a4cfb59bf801e02eb7844d6a27221beb3f5653e2aaaa23"
    sha256 cellar: :any_skip_relocation, tahoe: "57c5555b7e81c4cea3e07211106ca9e79e87a94865136193b8bcbae4a44b2930"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "437ad62201f5cce65671a592a8d774fb36eef4d7b7d2f8f3ee075ec53f4c5c2f"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "ee65bd33d36f121cd19b4026e964d788d069bfd4da575084cf2c84bd6805634b"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "4ddd35ac959d7f7b20a4d54bb3c20537d881f746c1439f99cf518b5d9348dba2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c34b3f3902f3eeaeebefb4e9a51181b303871f841a6d118ec1dcbbf1edf33e07"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.16.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aaf01719df5710b049f327da1c459742e2c49a24c6856964037fb3caf529c479"
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
