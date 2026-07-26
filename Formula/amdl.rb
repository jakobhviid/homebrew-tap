class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "1.4.1"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v1.4.1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b59f795d51924acbe674e1dac17d4a47e824edf13ec2b52cbfa0dafe2c84b2ba"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.4.1/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "43c5f28bd6b3f5b91b934872b770acac0bd27d23f458c0a9c649375b088c535e"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.4.1/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "fccb4a0fcbf44f366a8cc5431999b787fb7d5c1486cd8a7158be1148c51b3e6f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.4.1/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "869495180dc1e3faf7fa2811e6cf7896d89e7e2b0457d8d9ffe93d305f8b2184"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v1.4.1/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8d3b37884586608a20a7ac7999ee09763f1911ef8bd091d6cd872627dc1d295a"
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
