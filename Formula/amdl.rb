class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.12"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "04e6ee85319d43e448588300cbb5438579b1e7c4190ec22f7f6d99be564632f4"
    sha256 cellar: :any_skip_relocation, tahoe: "255d48cf0fe88d0b55ff712152624815a1d8a7454668d647ba37810264b17c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "31e247d0c18f1e9bc9ccbcb9234f5d09ce2caceb6a0948146d43628eaf2dd2b3"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "b15483539d5f184de8c6031c9a3edf6a7298133d3a2762cae196e1e0c66cc9d4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "b3737ab4d049d1e5299dcf5e66357414ef81ad85c8819b7f36b11698547525ef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e41f557d61d9dec0f89664f453db970a53d1e35c6210e8dd9b06480511d69761"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.12/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e1b3b712f56ed844aa19bcbfacb8fbda6027a573ae65fb615aacc09e9e3f6bba"
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
