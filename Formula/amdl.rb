class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.0.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a096a6c698a7687c45c86be58b03cd654bfae7b0b35e75c691ef6df34e28111"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.0.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "bb0646ad06bba1a7a8925c96014f7d57d94d39516b6ca78a3815aebade71b441"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.0.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "1a02bbe533c3b9c963e0da9aa63eaa8922b46d250a3470078ba5006c069d549d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.0.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5ba083fbacc1e5e624c5d27a70239bad215de968bef8ed242fdcbea759f9ae82"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.0.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1d88964a1ef34eb4883dd872a6f4a459eca2876a37ccb870d7168899096d6730"
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
