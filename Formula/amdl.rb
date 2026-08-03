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
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "386505d94d2d99ad86b76192f118faa3620fc3d5d67b1df36ec3ea0f5438c2a9"
    sha256 cellar: :any_skip_relocation, tahoe: "3578286affb2c6068d600b503b50d3874f3566a0d177ef0d99c9429a347ce640"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb2858626069fe8945e6eb70cea8c3188ead2755f30972765c9568c4e380c38b"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "c5a8f45799c60f4ec4beb739e41e483a5f9cc2de9948ea67772878d3f061fd15"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "7198c3392daacb7c89c65327cdd0b48b5f232e99de596d8372cc4a13a93d7442"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f610004005b01aa69ef8945dbcedf476bd4c9d2128eddcbb7cdbab10505a0b71"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v5.0.4/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "935ef11705f05e6e7b78df782e1da4365c855f71ce014adffcc05f884c9dedb3"
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
