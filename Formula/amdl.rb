class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.1.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.1.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6bc8ff15ca6728e55f5d22e76a600c57ce244f8030767765faa1da8bb546df2f"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "8977968994b3f346cbe44f24c515198bacfc30deb568c191b12f7f1a1b917d9a"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "1b24455871b7c650a8360ae7e2be6e9c32b2d34ff84a7b009ef5c7e39d38fde2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f761a0978dda83bda0fd208919eb5474512497028f484d1949e49df39f43c13c"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.1.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1feb044f607d105106e02f05ca100d2d980d20ebf02d59f16fd42ce9eff1cd5d"
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
