class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.10.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.10.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7f4a64f5a9c57499f53cf054f5cb3149345de154d816e156a37a75b66216d5d5"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.10.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "1bdb7f4ab42db761d1b8346d34bbb2048e482c2be592dd46bffe2bce1c93301a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.10.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "309595bc81eb742c14bac4f1c40e38cfd50db84347c5a50f68679ad1109e02c9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.10.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "95362c676c1b15b09ca3cd3b2073baf2ebe2f129bc0d32ef419301cc03893256"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.10.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fba38050e3390dae43338bd83c5d5c956cea2a90efd6d812aedba7734254f9a2"
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
