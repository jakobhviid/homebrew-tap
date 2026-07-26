class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc08ae7852c0e6fcbb2e9145ef2fd4669e9d3d9834a43a89e217e2bea5884e07"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "06feffa5093949987ac81ad50a500206f1fb5204ade0f4def7fd67f77a0f8504"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "f99d9a46364ba8a86254f64fc934c2edd1a35c7851350394e2b079f9cecc80a7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "56dd71bdaf2da60baa2d240d5e39075af24da41cf2fafa91cf7ee8636d6c6c16"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fbd8a2dff7a55af4fcf6b93fe3735600bcc1b04780a115905f222ad774979f9d"
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
