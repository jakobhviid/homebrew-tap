class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.17.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3108b692657509c1b557c17617e66ecb40c8a3159c3284b59fb352aef4628143"
    sha256 cellar: :any_skip_relocation, tahoe: "bc6f93b5b48cc5779517cb69de692b7e0e5b165b4c84add6ce05075a4fccdfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0ee9e3dbbe997779bbbd056a33f254f10b4c01031e4cf876a6496084f2532910"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.1/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "467aed0598ad2f7618b02bc7db758eb5e7ebb2d5a63a46fdc6f76c73e202af8e"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.1/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "a969756f720e46209c793e8f9851d8781b20af8055af9a68922223c9bc43beb0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.1/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4d985d16e96baee347cd617c75b8633e4a135be3c59bde2a0935897c3089fe3c"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.17.1/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e8c3318f640db1df4bd44d12b88df1cd9a039d25507772e5535cb9088dfd7053"
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
