class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.2.16"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.2.16"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ed190bb13ff193444dca76ae089e3d58cc331fd2ee99d478b8ac834f31267965"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.16/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "da857b1f183297f0a94358a938bbd32eb99a6b970675e7a1117b4bc83c7b186a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.16/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "32a503d1eae16ac464c95d85aff876d1921e283b3254f96e646655b6527d863d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.16/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0876aa2e942a2380c979fa49805e102a869331ff1001d97cd4917fbce912f52a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.16/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "921354016c57dafd596a165f8e06bc5989fcf6f2dd4714c96c45564c18b5acac"
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
