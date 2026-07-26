class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.7.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.7.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffc6a8a65f598e7aca778bee6ea4d7f70785a7392bff17263621f6263d0065f7"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "042a1c167f393501b3f6a971f049bdfbf04c5625df4193d74d0911661bc21fc8"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "c5aa065716e1952b8749892887bf9dd553f71342e8da16e7442871fa8c627678"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1c35e2b7b931d4a7df687596b865280c7a7f75ffeb1e12469c362e2c17f304c"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.7.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "440d9ce4ba261908ee3c446d2b9cc49e663575d93d88f987b7b0da8e2977e79f"
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
