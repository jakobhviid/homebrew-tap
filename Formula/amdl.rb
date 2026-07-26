class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.6"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9c2f9d32c1b2b03fc881a89f189a52c8d97ad08038f3cc03cc88b4609749fd26"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.6/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "78a80fe65baedfee99a6c928478da9b8d5851a158c1f815727b9afc44a4ad9c2"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.6/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "dde1a4dc6d1e51e6856df5875654d219971b0ac3e33b3170eac78656eb15cd95"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.6/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cda2fe523f949ee901425c2e477fca659fd27aadf6d8de4d2206b3fc0c4c5097"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.6/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4e25de659e07142b46ad8388332946f48567689da1160e20e4317722b31036e6"
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
