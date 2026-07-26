class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.8.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.8.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "289437865a83ad5a67a5320aacc8cf6a5143014cf8f30906af998d34889268ff"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.8.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "781f870c3d3534eb20ed354ae5e76e23156cec3cb59201849f700f9063cea609"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.8.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "fdbd7661c3e82f2402967020663ae2b1834511f6817ebd2339e86492037f25a6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.8.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fcf554b505cd3f74f8920c75130bdbd2796cabef7c4a4b178dcf7c32ab154e0e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.8.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "86bb412a30749886946c2706e94ecf780e6139c54e6cde71516a319222356f86"
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
