class Amdl < Formula
  desc "Music-library harness: validate, transcode to Opus, and organize (wraps gamdl + ffmpeg)"
  homepage "https://github.com/jakobhviid/amdl"
  version "3.0.5"
  license "MIT"

  # Prebuilt x86_64 Linux bottle so `brew install` pours it (no C compiler);
  # other platforms fall back to the url+install path below.
  bottle do
    root_url "https://github.com/jakobhviid/amdl/releases/download/v3.0.5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cc4d593f539964bec85116ae880942534cef9a189312e4cf5bd89f8f19753c4"
  end

  depends_on "chromaprint" # fpcalc, for `identify`
  depends_on "ffmpeg"
  depends_on "gamdl"

  on_macos do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.5/amdl-x86_64-apple-darwin.tar.gz"
      sha256 "f580639a79528677489720acd86cb0c08675728bb28ff950442905ea68141968"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.5/amdl-aarch64-apple-darwin.tar.gz"
      sha256 "2034384fb0b81eae18d1815e43c6d4d68bef8e45e2077d5098fcf9a96da0e609"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.5/amdl-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4d73a19a5ec44197fb6535c7cbb3d2e4062dde6bbf9c3b8798069fef2d7c8c57"
    end
    on_arm do
      url "https://github.com/jakobhviid/amdl/releases/download/v3.0.5/amdl-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3e3b9174831a93387cc62b625d238e9183049a27b3892299ffbf3180384766ee"
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
