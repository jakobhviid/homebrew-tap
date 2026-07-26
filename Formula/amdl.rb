class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "2.0.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v2.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3552fccaa602f00771ea0a39fa3508a8c08a42cb0b884b6cf2f63a13f423d0d5"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.0.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "b76241aecbe634a19fcfdf5aab9a4f5615034fc76bfaf0117781b883d2f3da48"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.0.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "4c877a42620fb9ee01a701f1da7067d05cd015c75712af28963290feb22d963e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.0.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "48f89416821d16b6ba5b521f15c9bbb30f968de2e16f30c70858c49b6c2ab501"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v2.0.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f5d901040c16b5457470096d2fbfb4939c90a64c55095d4ecd7751d554e513b9"
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
