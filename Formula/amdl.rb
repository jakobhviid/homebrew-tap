class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "5.0.5"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v5.0.5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cc41003dcafa1898b6f1c3aa050c0b6cd2fa9d6bda6a0cb28bc1d600e9330e7c"
    sha256 cellar: :any_skip_relocation, tahoe: "d1cfe3e4d11a4a830f797df76e7ffa91d641b0a4ab25209e8c67d0480897fc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "485cdfc12fc055ee8738697c35595948b956e340030872aad134c3b0ae5faf56"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.5/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "6f969efca4e4fa39ac03eb0e55edf0a06c4ada0d0473ddabe6a4e91776943dac"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.5/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c663411dfe322b454f414b6ec18a0ae3bf53f53b4795b6bf1b65618908121ca9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.5/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0641a18bd461c84666f85330e9e4fe8dec0faaa97c35298eec3d81d6d3344ead"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.5/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8c10abef13849e7e092aee1ebcc13d204b0c6c5cbbd9be355f57414de2bc6584"
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
