class Amdl < Formula
  desc "Maintain a uniform Opus music library: complete tags, cover art, and lyrics"
  homepage "https://github.com/jakobhviid/amdl"
  version "5.0.0"
  license "MIT"

  # Prebuilt bottles so `brew install` pours (no C compiler / Xcode gate):
  # macOS on both arches, plus x86_64 Linux. Anything without a matching bottle
  # — e.g. a macOS older than the build runner, or arm64 Linux — falls back to
  # the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v5.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e9f1bcc33b8d66400f3d94f9f8aaffcd730882b501ded74b15ff55ba1795a1d7"
    sha256 cellar: :any_skip_relocation, tahoe: "b19431f65ba23843387d19ed3d3b9df48064fe71fc60ed96fe46bb8d008f0fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "175b0b599bbfc72ae02f2a66f5eff0cd291524d40607cc435d2f062f9c6b204d"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "6d98e52db21f339001e387531b38a15ec7b2f4645786644993f918b3bfd9f765"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "7e37d28b0948144ddd1c860b8468cc3287122748ea94abbd34de4e7e825de77d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aad083f5615fc3f8b5da4c18161fe4f6e71d668830a00b6daa28c60ac0e33f24"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8619a0080a6ada92dab84ab84f12ea25b6f9a3dafb8208eaa6ee3be3cfc03542"
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
