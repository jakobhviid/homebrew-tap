class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.2.3"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.2.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d49520e98d23c654c0ad6f133e9e8d71bb8fe08a9e72ba2b3719fb86fdea5318"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.3/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "e040fdbb671a806d19652847dfde8a3400c6679e0dfaa020ac6caebb19bc81e4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.3/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "fcaec53a48a233e1c680956097d9a89e3d604b284796fff44b4f606237a5030e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.3/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f13573fc943bb71646270f9ec7ade1a6331f3c34ef11df3d7e9cc073a8765ff4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.3/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "649dfe235df7d14a3e0cd46ad1832614d64e95eaa3f3c8c1b45f8686e577e7c7"
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
