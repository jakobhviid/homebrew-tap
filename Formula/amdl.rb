class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.2.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.2.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a7a242dc02e45c09a1e4bbd909d2ccdcf279575270e278f904d48cae3d1a9bc"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "b44f2efe3aca8b6559f2eb0c0af2c7bc01cb5ff9c1551488187a6f7c7fb957c9"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c115ee279139f7b34508c0cac69562452d2d64db6932b555012ab579c6b0698e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5d3c2dfc3d68c775cefe53d3806d06ea56646b1b53bffd515ec3f57ff0176898"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "13b37934d45e754abb50d55403177a91970c69e3406a2b3234a1a32224a87b48"
    end
  end

  def install
    bin.install "amdl"
    generate_completions_from_executable(bin/"amdl", "completions")
    (man1/"amdl.1").write Utils.safe_popen_read(bin/"amdl", "man")
  end

  def caveats
    "Acquisition is handled by gamdl — install/configure it per its own terms. " \
      "amdl auto-detects Apple Music cookies from your browser (Safari/Chrome/Firefox/…); " \
      "on a headless host, pass them with `--cookies -`."
  end

  test do
    assert_match "amdl", shell_output("#{bin}/amdl --help")
  end
end
