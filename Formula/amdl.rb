class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.1.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.1.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "75a7ed5743640723eb1d234c5d777f413312d1fb7f968c25a48f6a09accfb0e4"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "b2f5c6e6f6021de2423a6d8c0ac865e07fda594e8d3602f3aaedbd10585fefd2"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "5676b00e36173a74227af39d519df3c4d28d7b73f711120db225621d80582133"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ffbc776debfd30b5a33998d36a4c213e8d984a7d81ce253c2123440bd6125046"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1bd13da8823007863d822e1ab202a107f5a271e67bdf8bf2cff4dd1374f705d0"
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
