class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "973ee759b818a6345519d6f93e5141855b6243ee622e31e9432d8f2e27fca350"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.1.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "b7e8d31135e7f099cf749c454436d82f8db6ce53f51a431af26730d2966c11af"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.1.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "30523abacf57c4a257060b465aa45a806a0d5f349331931ad7d07c85f5ce2635"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.1.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9e0d026308fc61c0200f1ef99990b467e2ffd6ca534a1ddbe454ad976c4a2ef7"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.1.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "69c1657a33652547954cd255d678a3d6b3b7ae64a404dbd059529a6028f51af6"
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
