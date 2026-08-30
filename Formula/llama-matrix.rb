class LlamaMatrix < Formula
  desc "Measure llama-swap model memory footprints and generate a co-residency matrix so as many models run concurrently as physically fit - without exceeding VRAM"
  homepage "https://github.com/jakobhviid/llama-matrix"
  version "1.11.3"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # - e.g. a macOS older than the build runner, or arm64 Linux - falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d3ea6c4087f1c501789dcb8bf4f435b4c52a47c63ccbd075e029edf220a259f2"
    sha256 cellar: :any_skip_relocation, tahoe: "cb20483d3b8fc7ab315f4f5ca9253538b8752c4b993ebb6338eff1b9c9e4f939"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a551eda24dcc5eb3114d239f852a1c800d6b95a8cc4d7d7b3d6c516eb02bfa41"
  end

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.3/llama-matrix-x86_64-apple-darwin.tar.gz"
      sha256 "8768b40ca5d1c11ad449fbd0b4f09da8b5a397f9e7827d39606c6ef2da945239"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.3/llama-matrix-aarch64-apple-darwin.tar.gz"
      sha256 "176d4a43eeddaa3a88220aa1886941205f0cb3b45126add3e50f1d354c9f7a34"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.3/llama-matrix-x86_64-unknown-linux-musl.tar.gz"
      sha256 "23d34df5e56d84707c8b29c93d37cd7fe6d4cf548af2082513731e9a830fcf9a"
    end
    on_arm do
      url "https://github.com/jakobhviid/llama-matrix/releases/download/v1.11.3/llama-matrix-aarch64-unknown-linux-musl.tar.gz"
      sha256 "92bf3dfe9ea5518bf39ac97cd8fd4169bf97bfa601a2e576da73327131becb22"
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
