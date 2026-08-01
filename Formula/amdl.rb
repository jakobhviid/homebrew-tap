class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "5.0.2"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v5.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "db1706f28f978c52f98b3349eed8ac4dd406cfac2229fb2ae5f29eafc2d99f80"
    sha256 cellar: :any_skip_relocation, tahoe: "ba25ef49da5dd990c0acfe4075b4566fd23901389f6361dd753d38757d661734"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a51eec73077dbce062af7d4cb5a6409bb390fa5fb072d7fd65ae77a77049bdee"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "12181f0a5d1816945f47e33772a2b807b54a7935cd7d6e460781ceba26f90407"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "cfb7f7676e4d6c19d2e34d1e10d0de3eaf39e249877d58f1c6c19354154e8ea4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d4e0cebd4fe07d2a281e9f16cc0d5d3fef53abdaf1682ef23e674899b50e887b"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "92a6956693c39337b970e83ba5a99fe2619af4ee7f9275e7c7d19058ad3a3f40"
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
