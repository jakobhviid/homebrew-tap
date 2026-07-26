class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.6.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.6.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0bd3f991bf8b813da3bc0ca999fd4cbfc4492f6539d74fcaaf4cded840dcad71"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.6.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "dd2ce1eb0ce2b286c142238a5d646369a6ab25755668741e00ddb003bc9dc373"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.6.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "7f923d91e189ebb1ca2481d6bed7fbb40c93ca562c95c2cca9b259d85c9769c1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.6.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ddfb4ea17a9f633102fa243440abc8c0b97b4c30208a43e0fbfbfaeead68927e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.6.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7c5a4d1f9d6381a59417ac5c5a02a1a49c002f742ffb053113643665c436cbe1"
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
