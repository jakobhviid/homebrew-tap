class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "4.2.0"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v4.2.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af45abc2c0d49ede92c88fe4c1f2dc32c3d15dcf7f5ace86280cfefdbfb12e52"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.0/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "0b240b9e7dc8e1b714e1f46d86211a79c0bc916401d79f319f8c71d1b2498dab"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.0/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "5080c11f38d3c209ef2553a375bf788e68eda976e2d29ed233a4f691a379cf55"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.0/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "748db1dd1dadc38121833df983123aef24fc8b4d354349a78e40f9ab69c16454"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v4.2.0/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "98c2c90415ca155bbf1e7a54629f39880541f53be9de26aa0937ecc0968d42ef"
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
