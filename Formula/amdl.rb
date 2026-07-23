class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.6"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.6/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "9599904627b4dddf99a27feb36b331a48f3dacb0fda17bf0d1113b4b9af34bc7"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.6/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "8a2510c5d4c9146402ebe1665e61f8ae8f6e0f69d4048fde5ade9bda58514fe0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.6/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "912f621e693dd19336096c15009e3849a41fbd166d487d18cd2b2e486d7f80be"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.6/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cacd97f9cc20eea36758453564b047d5889a8b8e1020c1412c9e2a7d59b09446"
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
