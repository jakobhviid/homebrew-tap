class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "5.0.4"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "9adb0fb57bb3d2377493368a85b2571ae68366514da40280ac787e0f328494b6"
    sha256 cellar: :any_skip_relocation, tahoe: "45c014d9789b155721155391e08c6e7227e0e0afb0eee0509b4ea4545bc2f4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "732d081a56294d970397fd1e0a36eb46e0da85c0a40220ff9c94c549ec8ae81e"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "0a7606d8215c62fca5f3b5bd89ee1f6d73a59b6f56a22816fdf4d7e8fe4f4df5"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "9f33ebab3d6662c4798f6f2cc6a7cb2bb69d286cf64674c848313afe5b7c73b4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "86b892e6afca04f66798ac6b25b643750d448852aac26c1584479b0eb9baa883"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b53ed92c4ff11f1ad2f8ec1f44bea53f6449e58fc1cea87218f4ea995e6591b5"
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
