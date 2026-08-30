class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.22.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ac830aca617c1767094d42cc08511b838e73bdb6300270e318d3bd0450ac0232"
    sha256 cellar: :any_skip_relocation, tahoe: "973ffc6b2993d00b529e50dd5c00d501f4a7a0fce55167023e2a86e1c6bd3a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee13af11342a000771d427399d0dc6c1c4c708adde8f00ac91d9cde11588a037"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.0/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "525279ae8e11be2f5ce5a93f1cf06b9933cf71e3abdfadbae49dad96fc70cfbe"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.0/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "3468c218a59acb2f20974bde00ea818fde6db32ac0775309a8d6c341e1d2b623"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.0/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "db30e7915718ad9c456bd90825d28307b2986e9b4a34a561a97bd7d4fc387b4f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.22.0/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f8490d097719532460fc0304debc765e8a19082444493ed9c7f644d2a0957e31"
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
