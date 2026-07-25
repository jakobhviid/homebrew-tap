class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.2.20"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.2.20"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e7a6e3b18537cfd6239af497981c1bda67ff4095a4ef73fdb34b8d0083f2ad7c"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.20/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "674490b134d209c35d3bc061446373b6b82a1d27100bf255b5ba9886af1c40f5"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.20/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "38fe954741277af8c45761d91e7c5616714461e800fafd471c732848a4e2f9a7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.20/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4302554ba0e45bc75af16fdff173cf934a9f525e99ceaffb50b309d0a9145a27"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.2.20/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "baa2a665d9ad6ee4b5957cd4ff81159eb4ccb07b140b65da636f1f3b7253ff65"
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
