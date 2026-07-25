class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.0.21"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.0.21"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a46b750139f95e694d8f0be9fbcfdc6aa5a42f807d9ec897b2d6e9812a059bd6"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.21/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "33941ba193f4838a1fc9b5c9db98f5450f2cb2cd05be48b83c5de4e74bb4abdd"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.21/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "5546b3db4f39cdd5589704738f4cf07eb7af27951fb9746152d9496fe0f5e289"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.21/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "912185950e6516871981bdff75bb3b5785c5e1cfa4de5e3b4ee390a4e15465a9"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.0.21/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6e04e7b7fb1abd2b55638c84cc117c43a23d6e3d0266364cc4425868af10d6a9"
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
