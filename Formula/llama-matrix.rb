class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.17.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "02bf1c1f515d38cbaa04bf529358ec379e86161825bdeaca7b1c6dd060f5ebcd"
    sha256 cellar: :any_skip_relocation, tahoe: "914ba9e5e1c03bbf2521521d8e1666b180a622dde1c2a597bee461417dc432b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b533a82a202ffb24a76f299f6066e1f047a13f24dbb287894341749ebb50f194"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.2/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "e95058253ca533a8aacbf0d80e2ab3703c9e8c7222a56f9b30e4444f04632994"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.2/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "e7e269ea601a67311de6156689be0b37e461fb65f9c3f8f1ada154ed9e79e44e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.2/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d8c51f0e7e328ce8ca7c7b57c8757d4076b4bef4e666083cbbb7a111d349cf4f"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.2/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec19b16b4cf3551702addc547ffbed93ddcdf02c96893da08178ffd46ba5ab34"
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
