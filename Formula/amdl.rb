class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.14"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v0.1.14"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e72602cfb7e2ceff896441969bf82981432ac69ad1dd3c3e2963a0d846dee7d"
  end

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.14/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "47c276c0e900dbbe3afe51654516195ea45a369d9bf596efe192593925afea72"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.14/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "e66d48fa5b44e129b49048845c977aa900afe29c6af3fe90399ec4c0dd629b0c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.14/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b340a1d185dc4590f27a0d7f52fd94b23f9e9f9daa0596c671e5cb4810babae"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.14/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "be2f0b2682da742f5b5009a7e55d179f45c0df0f1c23ede8bd8730a33e50bbcf"
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
