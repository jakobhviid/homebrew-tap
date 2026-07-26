class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc14f6f94e57d9053d51f0e92715a52fb3cce745db00c4b79987229e78411e9c"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "7f8863f8c40f78e2fecaec1b428a1f7378967b7aaae8f70c0c9a01f1253d85d6"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "ee085eac58b309d1b0fff6091ab4783da3aefd457afd16bc87aaaafae0d44aca"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b1685b0b4bca3b4a9b881d1bb3f37f165c5b907625ba67c4c94cc54bf212e19d"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b3b0b478fad0d25307e3eaca02a700fdf98a05e69cdb9a768c1f5ca30f71e807"
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
