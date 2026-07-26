class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.2"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d59716c8d7cbb552890b7a8529f87bdc17b00a8f2ec4011084fc5d999eff350"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.2/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "521fb8b6f878d9e619bd0c6f92a8690439c2b94289abe44451f8aa02603b449a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.2/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "ba1e80ffa7ee348a87bf80cdc93e75b430f3c54b58dcee2965fbfb0fcd4d7945"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.2/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d7e4d4006fbf0e3dea4010c928ea8035e2ce1f94f0de28d9892a02e6775c40a4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.2/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "469461f45af702243da6d79c5846eec65583f13f77e9ccd25da29bd5ca1d43f9"
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
