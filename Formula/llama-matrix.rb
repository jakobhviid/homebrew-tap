class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.19.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c77cc8b1334941e59f6996700c1eeb3f29bbbbe56b2aceeb99854a5c5b9b7b35"
    sha256 cellar: :any_skip_relocation, tahoe: "df6e34127c440907ca066e571a82ce1149b1505a9b45f0039cb9d86605c6f1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a6a86c8b304d832c581efcee3e852e1a95a54ed8d6c41f640048747d5e1e47cd"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "b001e25d0e31474ad679363eaa17f5d0e20d06a0501fc563763bc4907bd46c12"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "07bb8c8ebc7cab35c749dd26c9004f3056f8cbdcf7ff9a6def065419c9996685"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "136cb6235175dae256ee7d8f79b23845ffcaed3418ba69407b4d13c3731c0771"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.19.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0da6c2e8b2437cb816bf8dd9b15391f0a75f3bb8c214ef1334d116754853515d"
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
