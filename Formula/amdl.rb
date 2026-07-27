class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.3.1"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "91ac90200baa9af9e67af63d3fb3abea39bfe24f0db034637f122ae7f24a56ae"
    sha256 cellar: :any_skip_relocation, tahoe: "a71375a18922b842e0f6d6fc8860bcb29329d757642556f1a5214d09b029958a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b3b9141a24c6dab10ba92cf7ac6f35d9263013b06282081b398b687d087199a"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "057384c0e6dda7f975558bda3b5c6f6a59612f5407bc4f64a795446f0eb8fe0d"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "ceb7c2b1c033799e116ef0f8dd2d2dc513bd42de944e8077ffd35b3d7bdcdbc2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e83d6fe7d8e9b08b04dd9ca0905dd7ca0d8ba8c2a7ffaf5971bc2334988b540d"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bbcb0269c9edc49298ee6c8d25e4750d5959b09a42688e8d057617a448776b3f"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
