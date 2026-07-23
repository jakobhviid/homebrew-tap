class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "0.1.5"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.5/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "760731b27dda1c779a10734dac1b7b987e769aa6c5c1aa1d6887a9e5e2978575"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.5/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "f6094407c0ba89ea39277bb5a0ea43309984d8b9184092b16b55eb58dcc4aee9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.5/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aced20a211003e2d58cff30c9bfb48da3163e99ec1ec9e2974ee5a3d8fb2f7da"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v0.1.5/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a2314b17ca7c41074583dc0da21cd8664a2ae9eb3382252df43fe029b6858df4"
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
