class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.3.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.3.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "89604919bb568c285abf39b1769de2f91bc5401a7543e5797ee7df5250acae7d"
    sha256 cellar: :any_skip_relocation, tahoe: "4951f6a7473994aa0b64d614a158ecd12023d33a819320de814af13abf965582"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "da347175d38be826ad9172a1c59ce7c20b9e5ffff0bfc27a841d17bb6a9b7933"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "48f2b3c6d8977e6458a6c2a9edac5cfe57032f808142050ad48078c58f01f1f4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c60d6220d1620b4fa10c62d9298d6e0a973789908040c71b2f6982d409819c6c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1f57028195672f2ed622e8182785fe3f333692a82b6e250cf4dcdd41ea1db246"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1d00190ad7ad1f6f4ae6f08435ad3068b8435d80cc919aa11cceacd7cdb0b06c"
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
