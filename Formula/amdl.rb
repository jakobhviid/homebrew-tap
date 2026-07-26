class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.3.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.3.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a206e85159f6b4ae2af904e164fb966caa194032c2ad23b6378434c7f0aac6a9"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.3.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "7a319c9dfef3358b07d1464ab8a38e2df69c0dfbe886396c4a11266564c7d0b4"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.3.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "bad6f57607cf8f8847ac8799ed64b557e9600b28c357f2acf1e3f5a383c618ef"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.3.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "99866e3b1481aa55990869c99b759a724045ef349b3f0e10dc27f8c4086fd52c"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.3.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7891d8d8afc9c1677742fd34cbc116e5c9145c76c773eccec90667b4aab749ac"
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
