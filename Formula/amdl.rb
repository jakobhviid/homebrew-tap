class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.2.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.2.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f6e78f4a4dafc53cc38e4845f242e7305215fca686f505c71c9e95a2be678707"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "f76842a836ac8a4849db95ee9b0ad9aebbbc80e1ac90ce9f7831d91048db0932"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "18c57c9d6437726003dcdb002ec9e6f8f1e2e51f7ee196ee077c607cc4544a68"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9cb0af373e241aefa395da41ea696f5cd361763fffe4a8a25f38a5ed4f70b342"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.2.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cebee28fe84e3ad31655b851a720c298a9457364ddad5cfe106c400b7ba877cc"
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
