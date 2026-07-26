class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.3"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "550951053c904be421c8d619657ff87caabd760ea21165e86427a6e1f4b55a2e"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.3/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "498a0adcdf7b584185ccb660cfe13cdb7ab80ea0813006afd8625228586e6736"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.3/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "a7818ca613d5db89dee2a71c43e285359d4f2a0fd39b0ea7a0331eb14008dd41"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.3/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4fb26ef50e77e45b9ea715d712aaabf315bd7aa9ad2b0caa4c416f12d9df8947"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.3/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8e8e06deddd4b8cd56da1c20247c208d872381c3d0c135f68fd55d95b6f5f585"
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
