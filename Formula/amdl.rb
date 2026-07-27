class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.10"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "51aa36b3b36e7311a66ee3e89d585d9405ef286254c3e256ac4bedc2fa4c9e02"
    sha256 cellar: :any_skip_relocation, tahoe: "39b1d4c66be7b9b9160ebd7c0ac6363e01b450f9c7c9748f95886ae382e9dbb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34bbad2ca739fa2c92734fc8353949fb0faa2267f742cae63c1db4813d10f351"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.10/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "269192b0c72f27a487983a35557483c1f5fac648b6baffc7c17c1e4d3c9591c7"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.10/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "503923ebc0a175eccd3d6c88ebfeeb09b0200903b98e512d331b4c1891044a3e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.10/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2028ea1b74a7bdf8e8180a0f1ca12b8ea31f76badc0aefb580812b9a5f95bd62"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.10/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fe21a02787ccac764edf7b4028d50efad6ac2241f945dc8c5fa3cad427345322"
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
