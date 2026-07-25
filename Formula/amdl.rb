class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.2.18"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.2.18"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f7889799269424bd53ea29b8590b9cc79e76a88224f92749f85f08756767eb87"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.18/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "c52bebbdf3b493d4ee3f50c93cdb864307622823111b9f76cf25d13b5cb53043"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.18/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "1c6f6d12d48f64e680468ea00efd26e98dd90d153dc6c469b26544ab79ee3a63"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.18/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fa458e9a0f3a6ce11365bf338f7fcd9cbf874527c8b589e7262ff8fc0d7b7457"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.18/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "82f409e64625ef159f50d515f0a6666c5e8a6e7b5710e939cc79b1a8427b0280"
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
