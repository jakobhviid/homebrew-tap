class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.3.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "8b47c533a34115b2c48693bff56430b314986f2635955c49a82b14c439d2e2a6"
    sha256 cellar: :any_skip_relocation, tahoe: "37220ed79c0f823b85d27c6313baf6f82b8226266d3f7ee36d2e91c1635256cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f3da7dcc957671700c970bae9ef4403c77f3d1145cde6d2e1730e502d45c39e0"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "8121220f503f01d84844456c28ad192cdaa634e6649e419a288fca387ec31043"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "3a329c56cf7ce3f47672dcf977a44a3a093f34d7f71f23a2ce3e9bee6d12c96a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "544379040fa94c559e496a8b09fdadb3d9d83478d20c690c54034e896c0b7f51"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.3.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ab10568b327ff629cc4fc14f0a1ec63ba1275c437fc188dbd40a8a55dba1e887"
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
